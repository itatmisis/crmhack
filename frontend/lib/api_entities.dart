import 'package:json_annotation/json_annotation.dart';

part 'api_entities.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProcessAudioResponse {
  final Noise noise;
  final Politness politness;
  final TextSpeed textSpeed;
  final RecognizedText recognizedText;
  final String bertCommas;
  final Sentiments sentiments;
  final List<double> bertParted;

  ProcessAudioResponse(this.noise, this.politness, this.textSpeed,
      this.recognizedText, this.bertCommas, this.sentiments, this.bertParted);

  factory ProcessAudioResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessAudioResponseFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecognizedText {
  String text;
  List<Result>? result;

  RecognizedText(this.result, this.text);

  factory RecognizedText.fromJson(Map<String, dynamic> json) =>
      _$RecognizedTextFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Result {
  double conf;
  double end;
  double start;
  String word;

  Result(this.conf, this.end, this.start, this.word);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Sentiments {
  String predictedClass;
  List<double>? conf;

  // List<List> wordAttributions;

  Sentiments(this.predictedClass, this.conf);

  factory Sentiments.fromJson(Map<String, dynamic> json) =>
      _$SentimentsFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TextSpeed {
  double mean;
  String speedClass;
  String comment;

  TextSpeed(this.mean, this.speedClass, this.comment);

  factory TextSpeed.fromJson(Map<String, dynamic> json) =>
      _$TextSpeedFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Noise {
  double noiseLevel;
  String comment;

  Noise(this.noiseLevel, this.comment);

  factory Noise.fromJson(Map<String, dynamic> json) => _$NoiseFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Politness {
  final double positive;
  final double friendly;
  final double clear;
  final double formal;
  final double average;

  Politness(
      this.positive, this.friendly, this.clear, this.formal, this.average);

  factory Politness.fromJson(Map<String, dynamic> json) =>
      _$PolitnessFromJson(json);
}
