// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessAudioResponse _$ProcessAudioResponseFromJson(Map<String, dynamic> json) {
  return ProcessAudioResponse(
    Noise.fromJson(json['noise'] as Map<String, dynamic>),
    Politness.fromJson(json['politness'] as Map<String, dynamic>),
    TextSpeed.fromJson(json['text_speed'] as Map<String, dynamic>),
    RecognizedText.fromJson(json['recognized_text'] as Map<String, dynamic>),
    json['berd_commas'] as String,
    Sentiments.fromJson(json['sentiments'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProcessAudioResponseToJson(
        ProcessAudioResponse instance) =>
    <String, dynamic>{
      'noise': instance.noise,
      'politness': instance.politness,
      'text_speed': instance.textSpeed,
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

TextSpeed _$TextSpeedFromJson(Map<String, dynamic> json) {
  return TextSpeed(
    (json['mean'] as num).toDouble(),
    json['speed_class'] as String,
    json['comment'] as String,
  );
}

Map<String, dynamic> _$TextSpeedToJson(TextSpeed instance) => <String, dynamic>{
      'mean': instance.mean,
      'speed_class': instance.speedClass,
      'comment': instance.comment,
    };

Noise _$NoiseFromJson(Map<String, dynamic> json) {
  return Noise(
    (json['noise_level'] as num).toDouble(),
    json['comment'] as String,
  );
}

Map<String, dynamic> _$NoiseToJson(Noise instance) => <String, dynamic>{
      'noise_level': instance.noiseLevel,
      'comment': instance.comment,
    };

Politness _$PolitnessFromJson(Map<String, dynamic> json) {
  return Politness(
    (json['positive'] as num).toDouble(),
    (json['friendly'] as num).toDouble(),
    (json['clear'] as num).toDouble(),
    (json['formal'] as num).toDouble(),
    (json['average'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PolitnessToJson(Politness instance) => <String, dynamic>{
      'positive': instance.positive,
      'friendly': instance.friendly,
      'clear': instance.clear,
      'formal': instance.formal,
      'average': instance.average,
    };
