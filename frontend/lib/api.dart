import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'api_entities.dart';

const serverAddress = "https://crmhack.itatmisis.ru:9999";
const graphGifUrl = serverAddress + "/graph_generate_gif";

Future<ProcessAudioResponse> processAudio(List<int> audio) async {
  var request =
      http.MultipartRequest("POST", Uri.parse(serverAddress + "/load_audio"));
  request.files
      .add(http.MultipartFile.fromBytes('audio', audio, filename: "test.webm"));

  final response = await http.Client().send(request);
  var responseBody = await response.stream.bytesToString();
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  return ProcessAudioResponse.fromJson(parsed);
}
