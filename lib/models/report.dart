import 'package:json_annotation/json_annotation.dart';
import 'package:purrfectmatch/models/annonce.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final int? id;
  final String reporterUserId;
  final String reportedUserId;
  final DateTime? createdAt;
  final int reasonID;
  final bool? isHandled;
  final int? messageID;
  final Annonce? annonce;

  Report({
    this.id,
    required this.reporterUserId,
    required this.reportedUserId,
    this.createdAt,
    required this.reasonID,
    this.isHandled,
    this.messageID,
    this.annonce,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
