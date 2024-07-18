import 'package:json_annotation/json_annotation.dart';

part 'reason.g.dart';

@JsonSerializable()
class Reason {
  final int id;
  final String reason;

  Reason({required this.id, required this.reason});

  factory Reason.fromJson(Map<String, dynamic> json) => _$ReasonFromJson(json);
}
