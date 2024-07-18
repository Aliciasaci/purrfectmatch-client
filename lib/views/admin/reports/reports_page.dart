import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/blocs/reports/report_bloc.dart';
import 'package:purrfectmatch/models/reason.dart';
import 'package:purrfectmatch/models/report.dart';
import 'package:purrfectmatch/services/api_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ApiService apiService = ApiService();
  List<Reason> reasons = [];
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    BlocProvider.of<ReportBloc>(context).add(FetchReports());
    reasons = await apiService.getReportReasons();
  }

  String getLocalizedReason(String reasonKey) {
    switch (reasonKey) {
      case "inappropriateContent":
        return "Contenu inapproprié";
      case "spam":
        return "Spam";
      case "other":
        return "Autre";
      case "illegalContent":
        return "Contenu illégal";
      case "harassment":
        return "Harcèlement";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ReportLoaded) {
                  final messageReports = state.reports
                      .where((report) => report.type == 'message')
                      .toList();
                  final annonceReports = state.reports.where((report) {
                    return report.type == 'annonce';
                  }).toList();

                  return Column(
                    children: [
                      _buildReportMessageTable(messageReports),
                      const SizedBox(height: 200),
                      _buildReportAnnonceTable(annonceReports),
                    ],
                  );
                } else if (state is ReportError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                      child: Text('Aucun report pour l\'instant.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportAnnonceTable(List<Report> reports) {
    return FutureBuilder<List<DataRow>>(
      future: Future.wait(reports.map((report) async {
        final reporter = await apiService.fetchUserByID(report.reporterUserId);
        final reported = await apiService.fetchUserByID(report.reportedUserId);
        final translateReason = getLocalizedReason(report.reason!);
        return DataRow(cells: [
          DataCell(Text(report.annonce!.Title, overflow: TextOverflow.ellipsis),
              onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(report.annonce!.Description),
                );
              },
            );
          }),
          DataCell(
              Text(report.annonce!.Description,
                  overflow: TextOverflow.ellipsis), onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(report.annonce!.Description),
                );
              },
            );
          }),
          DataCell(Text(reporter.name)),
          DataCell(Text(reported.name)),
          DataCell(Text(translateReason)),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
                IconButton(
                    icon: const Icon(Icons.block, color: Colors.red),
                    onPressed: () {}),
              ],
            ),
          ),
        ]);
      }).toList()),
      builder: (BuildContext context, AsyncSnapshot<List<DataRow>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Titre annonce')),
                  DataColumn(label: Text('Description annonce')),
                  DataColumn(label: Text('Reporter')),
                  DataColumn(label: Text('Reporté')),
                  DataColumn(label: Text('Raison')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: snapshot.data!,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildReportMessageTable(List<Report> reports) {
    return FutureBuilder<List<DataRow>>(
      future: Future.wait(reports.map((report) async {
        final reporter = await apiService.fetchUserByID(report.reporterUserId);
        final reported = await apiService.fetchUserByID(report.reportedUserId);
        final translateReason = getLocalizedReason(report.reason!);
        return DataRow(cells: [
          DataCell(
            Text(report.message!, overflow: TextOverflow.ellipsis),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content:
                        Text(report.message!), // Show the full message here
                  );
                },
              );
            },
          ),
          DataCell(Text(reporter.name)),
          DataCell(Text(reported.name)),
          DataCell(Text(translateReason)),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ]);
      }).toList()),
      builder: (BuildContext context, AsyncSnapshot<List<DataRow>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Message')),
                  DataColumn(label: Text('Reporter')),
                  DataColumn(label: Text('Reporté')),
                  DataColumn(label: Text('Raison')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: snapshot.data!,
              ),
            ),
          );
        }
      },
    );
  }
}
