import 'package:json_annotation/json_annotation.dart';

part 'weather_response_condition.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Condition {
  final String text;
  final String icon;
  final int code;
  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });
  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionToJson(this);

  Condition copyWith({
    String? text,
    String? icon,
    int? code,
  }) {
    return Condition(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      code: code ?? this.code,
    );
  }
}
