import 'package:json_annotation/json_annotation.dart';
import 'package:purrfectmatch/models/annonce.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final int? id;
  final String reporterUserId;
  final String reportedUserId;
  final DateTime? createdAt;
  final int? reasonId;
  final bool? isHandled;
  final int? messageId;
  final Annonce? annonce;
  final int? annonceId;
  final String? type;
  final String? message;
  final String? reason;

  Report({
    this.id,
    required this.reporterUserId,
    required this.reportedUserId,
    this.createdAt,
    this.reasonId,
    this.isHandled,
    this.messageId,
    this.annonce,
    this.annonceId,
    this.type,
    this.message,
    this.reason,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
