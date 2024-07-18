import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/report.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:web_socket_channel/io.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ApiService apiService;
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  ReportBloc({required this.apiService}) : super(ReportInitial()) {
    on<FetchReports>(_onFetchReports);
    on<CreateReportMessage>(_onCreateReportMessage);
    on<CreateReportAnnonce>(_onCreateReportAnnonce);
    on<NewReportReceived>(_onNewReportReceived);
  }

  void initializeWebSocket() {
    _channel = apiService.connectToReportStream();
    _subscription = _channel!.stream.listen((message) {
      final reportJson = jsonDecode(message);
      final report = Report.fromJson(reportJson);
      add(NewReportReceived(report));
    });
  }

  Future<void> _onFetchReports(
      FetchReports event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final reports = await apiService.getAllReports();
      emit(ReportLoaded(reports));
      initializeWebSocket();
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onCreateReportMessage(
      CreateReportMessage event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      await apiService.createReportMessage(
        event.report.messageId!,
        event.report.reporterUserId,
        event.report.reportedUserId,
        event.report.reasonId,
      );
      emit(ReportCreated());
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onCreateReportAnnonce(
      CreateReportAnnonce event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      await apiService.createReportAnnonce(
        event.report.annonce!.ID!,
        event.report.reporterUserId,
        event.report.reportedUserId,
        event.report.reasonId,
      );
      emit(ReportCreated());
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  void _onNewReportReceived(
      NewReportReceived event, Emitter<ReportState> emit) {
    final currentState = state;
    if (currentState is ReportLoaded) {
      emit(ReportLoaded([event.report, ...currentState.reports]));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
