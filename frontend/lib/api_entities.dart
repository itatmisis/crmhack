import 'package:json_annotation/json_annotation.dart';

part 'api_entities.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProcessAudioResponse {
  final double noise;
  final TextSpeed textSpeed;
  final RecognizedText recognizedText;
  final String berdCommas;
  final Sentiments sentiments;

  ProcessAudioResponse(this.noise,this.textSpeed, this.recognizedText,this.berdCommas, this.sentiments);
  factory ProcessAudioResponse.fromJson(Map<String, dynamic> json) => _$ProcessAudioResponseFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RecognizedText {
  String text;
  List<Result>? result;

  RecognizedText(this.result, this.text);

  factory RecognizedText.fromJson(Map<String, dynamic> json) => _$RecognizedTextFromJson(json);
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

  factory Sentiments.fromJson(Map<String, dynamic> json)  => _$SentimentsFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TextSpeed {
  double mean;
  String speedClass;

  TextSpeed(this.mean, this.speedClass);

  factory TextSpeed.fromJson(Map<String, dynamic> json)  => _$TextSpeedFromJson(json);
}
