/*
 * Copyright 2018, 2019, 2020 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3 (LGPL-V3), as published by
 * the Free Software Foundation.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Flutter-Sound.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:frontend/api_entities.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'api.dart';
import 'audio_util/get_track_url.dart';
import 'dashboard_page.dart';
import 'audio_util/temp_file.dart';

import 'audio_util/demo_active_codec.dart';
import 'audio_util/recorder_state.dart';
import 'package:file_picker/file_picker.dart';

var teamLogoImage = Image(image: AssetImage('assets/team_logo.png'));

const myFavoriteWhite = Color.fromARGB(1, 250, 250, 250);

class MainBody extends StatefulWidget {
  const MainBody({
    Key? key,
  }) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  bool initialized = false;
  bool recording = false;

  String? recordingFile;
  Uint8List? fileBytes;
  late Track track;

  @override
  void initState() {
    if (!kIsWeb) {
      var status = Permission.microphone.request();
      status.then((stat) {
        if (stat != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }
      });
    }
    super.initState();
    tempFile(suffix: '.webm').then((path) {
      recordingFile = path;
      track = Track(
        trackPath: recordingFile,
      );
      setState(() {});
    });
  }

  Future<bool> init() async {
    if (!initialized) {
      await initializeDateFormatting();
      await UtilRecorder().init();
      ActiveCodec().recorderModule = UtilRecorder().recorderModule;
      ActiveCodec().setCodec(withUI: false, codec: Codec.aacADTS);

      initialized = true;
    }
    return initialized;
  }

  void _clean() async {
    if (recordingFile != null) {
      try {
        await File(recordingFile!).delete();
      } on Exception {
        // ignore
      }
    }
  }

  @override
  void dispose() {
    _clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: false,
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return Container(
              width: 0,
              height: 0,
              color: Colors.white,
            );
          } else {
            return ListView(
              children: <Widget>[
                SizedBox(height: 100),
                SizedBox(
                  width: 500,
                  child: teamLogoImage,
                ),
                SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        _buildRecorder(track),
                        RaisedButton(
                          color: favoriteBlueColor,
                          child: const Text("Process audio"),
                          onPressed:
                              _getTrackPath() != null || fileBytes != null
                                  ? _onProcessRecord
                                  : null,
                        ),
                        SizedBox(width: 20, height: 20),
                        RaisedButton.icon(
                          icon: Icon(Icons.attach_file),
                          color: favoriteBlueColor,
                          label: const Text("Pick .webm"),
                          onPressed: _onPickFile,
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    _buildQR(),
                  ],
                ),
              ],
            );
          }
        });
  }

  Widget _buildRecorder(Track track) {
    var hasTrack = _getTrackPath() != null;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RecorderPlaybackController(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (recording)
                SizedBox(
                  width: 400,
                  child: SoundRecorderUI(
                    track,
                    backgroundColor: myFavoriteWhite,
                    showTrashCan: false,
                    onStopped: (media) {
                      setState(() {
                        recording = false;
                      });
                    },
                    pausedTitle: "Paused",
                    recordingTitle: "Recording",
                    stoppedTitle: "Stopped",
                  ),
                ),
              if (!recording)
                SizedBox(
                  width: 400,
                  child: SoundPlayerUI.fromTrack(
                    track,
                    backgroundColor: myFavoriteWhite,
                    enabled: hasTrack,
                    showTitle: true,
                    audioFocus: AudioFocus.requestFocusAndDuckOthers,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  textTheme: ButtonTextTheme.primary,
                  color: favoriteBlueColor,
                  child: Icon(Icons.mic),
                  shape: CircleBorder(),
                  onPressed: () {
                    setState(() {
                      recording = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildQR() {
    final double size = 300;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Center(
        child: Container(
          height: size,
          width: size,
          child: QrImage(
            data: "https://github.com/itatmisis/crmhack",
            version: QrVersions.auto,
            size: size,
          ),
        ),
      ),
    );
  }

  _onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List newFileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;
      setState(() {
        fileBytes = newFileBytes;
      });
    }
  }

  String? _getTrackPath() {
    var trackPath = track.trackPath!;
    trackPath = getRecordURL(trackPath);
    if (trackPath == null || trackPath == "") {
      return null;
    }
    return trackPath;
  }

  _onProcessRecord() async {
    var trackPath = _getTrackPath();
    if (trackPath == null && fileBytes == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("null recorded audio"),
      ));
      return;
    }
    Uint8List data;
    if (fileBytes != null) {
      data = fileBytes!;
    } else if (kIsWeb) {
      final result = await http.get(Uri.parse(trackPath!));
      data = result.bodyBytes;
    } else {
      var f = File(trackPath!);
      data = await f.readAsBytes();
    }

    ProcessAudioResponse? globalResponse;

    var isOk = await showDialog<bool>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Processing audio..."),
            children: [
              Center(
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      FutureBuilder<ProcessAudioResponse>(
                        future: processAudio(data.toList()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            globalResponse = snapshot.data!;
                            Navigator.of(context).pop(true);
                            return Text("");
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: const CircularProgressIndicator(),
                          );
                        },
                      ),
                      Center(
                        child: ElevatedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });

    if (isOk != null && isOk && globalResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(globalResponse!)),
      );
    }
  }
}
