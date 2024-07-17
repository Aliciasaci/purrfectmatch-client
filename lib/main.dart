import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purrfectmatch/blocs/reports/report_bloc.dart';
import 'package:purrfectmatch/blocs/room/room_bloc.dart';
import 'package:purrfectmatch/models/report.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/views/admin/admin_home_page.dart';
import 'package:purrfectmatch/views/admin/association/blocs/association_bloc.dart';
import 'package:purrfectmatch/views/admin/association/list_association.dart';
import 'package:purrfectmatch/views/admin/race/blocs/crud_race_bloc.dart';
import 'package:purrfectmatch/views/admin/race/crud_race_page.dart';
import 'package:purrfectmatch/views/admin/user/blocs/crud_user_bloc.dart';
import 'package:purrfectmatch/views/admin/user/crud_user_page.dart';
import 'package:purrfectmatch/views/not_found_page.dart';
import 'package:purrfectmatch/views/user/profile/create_association.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'appAuthLinks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blocs/auth/auth_bloc.dart';
import 'services/auth_service.dart';
import 'views/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import './views/language_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService authService = AuthService();
  final DynamicLinkHandler _appLinksDeepLink = DynamicLinkHandler.instance;

  @override
  Widget build(BuildContext context) {
    kIsWeb
        ? _appLinksDeepLink.initialize()
        : null; // Initialize deep links when the app starts

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider<RoomBloc>(
          create: (context) => RoomBloc(apiService: ApiService()),
        ),
        BlocProvider<ReportBloc>(
          create: (context) => ReportBloc(apiService: ApiService()),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: '',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.blueGrey[50],
                ),
                scaffoldBackgroundColor: Colors.blueGrey[50],
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeProvider.locale,
              home: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    if (state.user.roles.any((role) => role.name == 'ADMIN')) {
                      Navigator.of(context).pushReplacementNamed('/admin');
                    } else if (state.user.roles
                        .any((role) => role.name == 'USER')) {
                      Navigator.of(context).pushReplacementNamed('/user');
                    } else if (state.user.roles
                        .any((role) => role.name == 'ASSO')) {
                      Navigator.of(context).pushReplacementNamed('/asso');
                    } else {
                      Navigator.of(context).pushReplacementNamed('/not-found');
                    }
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthInitial) {
                      return const LoginPage();
                    } else if (state is AuthLoading) {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is AuthError) {
                      return Scaffold(
                        body: Center(
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return const LoginPage();
                    }
                  },
                ),
              ),
              routes: {
                '/admin': (context) => const AdminHomePage(title: ''),
                '/admin/users': (context) => BlocProvider(
                      create: (context) =>
                          CrudUserBloc(apiService: ApiService())
                            ..add(LoadUsers()),
                      child: const CrudUserPage(),
                    ),
                '/admin/races': (context) => BlocProvider(
                      create: (context) =>
                          CrudRaceBloc(apiService: ApiService())
                            ..add(LoadRaces()),
                      child: const CrudRacePage(),
                    ),
                '/admin/associations': (context) => BlocProvider(
                      create: (context) =>
                          AssociationBloc(apiService: ApiService())
                            ..add(LoadAssociations()),
                      child: const ListAssociation(),
                    ),
                '/not-found': (context) =>
                    const NotFoundPage(title: 'Page not found'),
                '/user': (context) => const UserHomePage(title: ''),
                '/user/create-association': (context) =>
                    const CreateAssociation(),
              },
            );
          },
        ),
      ),
    );
  }
}
