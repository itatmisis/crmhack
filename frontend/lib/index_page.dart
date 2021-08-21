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
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:js/js.dart';
import 'api.dart';
import 'dashboard_page.dart';
import 'audio_util/temp_file.dart';

import 'audio_util/demo_active_codec.dart';
import 'audio_util/recorder_state.dart';

class MainBody extends StatefulWidget {
  const MainBody({
    Key? key,
  }) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  bool initialized = false;

  String? recordingFile;
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
            return Column(
              children: <Widget>[
                _buildRecorder(track),
                _buildQR(),
                ElevatedButton(
                  child: const Text('Go to dashboard page'),
                  onPressed: () async {
                    var trackPath = track.trackPath!;
                    if (kIsWeb) {
                      trackPath = getRecordURL(trackPath);
                    }
                    final result = await http.get(Uri.parse(trackPath));
                    var data = result.bodyBytes;
                    if (data == null) {
                      // TODO
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("null recorded audio"),
                      ));
                      return;
                    }
                    var response = await processAudio(data.toList());
                    if (response == null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("invalid response from server"),
                      ));
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPage(response)),
                    );
                  },
                ),
              ],
            );
          }
        });
  }

  Widget _buildRecorder(Track track) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RecorderPlaybackController(
          child: Column(
            children: [
              Left('Recorder'),
              SoundRecorderUI(track, showTrashCan: false),
              Left('Recording Playback'),
              SoundPlayerUI.fromTrack(
                track,
                enabled: false,
                showTitle: true,
                audioFocus: AudioFocus.requestFocusAndDuckOthers,
              ),
            ],
          ),
        ));
  }

  Widget _buildQR() {
    final double size = 250;
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
}

class Left extends StatelessWidget {
  final String label;

  Left(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4, left: 8),
      child: Container(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

@JS('getRecordURL')
external String getRecordURL(
  String path,
);
