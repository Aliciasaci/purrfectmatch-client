part of 'report_bloc.dart';

abstract class ReportEvent {}

class FetchReports extends ReportEvent {}

class CreateReportMessage extends ReportEvent {
  final Report report;

  CreateReportMessage({
    required this.report,
  });
}

class CreateReportAnnonce extends ReportEvent {
  final Report report;

  CreateReportAnnonce({required this.report});
}

class NewReportReceived extends ReportEvent {
  final Report report;

  NewReportReceived(this.report);
}
