// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: (json['id'] as num).toInt(),
      reporterUserId: json['reporterUserId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      reasonID: (json['reasonID'] as num).toInt(),
      isHandled: json['isHandled'] as bool,
      messageID: (json['messageID'] as num?)?.toInt(),
      annonce: json['annonce'] == null
          ? null
          : Annonce.fromJson(json['annonce'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'reporterUserId': instance.reporterUserId,
      'reportedUserId': instance.reportedUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'reasonID': instance.reasonID,
      'isHandled': instance.isHandled,
      'messageID': instance.messageID,
      'annonce': instance.annonce,
    };
