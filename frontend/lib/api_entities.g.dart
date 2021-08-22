// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessAudioResponse _$ProcessAudioResponseFromJson(Map<String, dynamic> json) {
  return ProcessAudioResponse(
    (json['noise'] as num).toDouble(),
    RecognizedText.fromJson(json['recognized_text'] as Map<String, dynamic>),
    json['berd_commas'] as String,
    Sentiments.fromJson(json['sentiments'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProcessAudioResponseToJson(
        ProcessAudioResponse instance) =>
    <String, dynamic>{
      'noise': instance.noise,
      'recognized_text': instance.recognizedText,
      'berd_commas': instance.berdCommas,
      'sentiments': instance.sentiments,
    };

RecognizedText _$RecognizedTextFromJson(Map<String, dynamic> json) {
  return RecognizedText(
    (json['result'] as List<dynamic>?)
        ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['text'] as String,
  );
}

Map<String, dynamic> _$RecognizedTextToJson(RecognizedText instance) =>
    <String, dynamic>{
      'text': instance.text,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
    (json['conf'] as num).toDouble(),
    (json['end'] as num).toDouble(),
    (json['start'] as num).toDouble(),
    json['word'] as String,
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'conf': instance.conf,
      'end': instance.end,
      'start': instance.start,
      'word': instance.word,
    };

Sentiments _$SentimentsFromJson(Map<String, dynamic> json) {
  return Sentiments(
    json['predicted_class'] as String,
    (json['conf'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
  );
}

Map<String, dynamic> _$SentimentsToJson(Sentiments instance) =>
    <String, dynamic>{
      'predicted_class': instance.predictedClass,
      'conf': instance.conf,
    };
