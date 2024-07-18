// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: (json['id'] as num?)?.toInt(),
      reporterUserId: json['reporterUserId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      reasonId: (json['reasonId'] as num).toInt(),
      isHandled: json['isHandled'] as bool?,
      messageId: (json['messageId'] as num?)?.toInt(),
      annonce: json['annonce'] == null
          ? null
          : Annonce.fromJson(json['annonce'] as Map<String, dynamic>),
      annonceId: (json['annonceId'] as num?)?.toInt(),
      type: json['type'] as String?,
      message: json['message'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'reporterUserId': instance.reporterUserId,
      'reportedUserId': instance.reportedUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'reasonId': instance.reasonId,
      'isHandled': instance.isHandled,
      'messageId': instance.messageId,
      'annonce': instance.annonce,
      'annonceId': instance.annonceId,
      'type': instance.type,
      'message': instance.message,
      'reason': instance.reason,
    };
