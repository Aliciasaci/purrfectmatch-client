import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purrfectmatch/blocs/room/room_bloc.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/views/admin/admin_home_page.dart';
import 'package:purrfectmatch/views/admin/crud_user_page.dart';
import 'package:purrfectmatch/views/not_found_page.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';
import 'blocs/auth_bloc.dart';
import 'services/auth_service.dart';
import 'views/login.dart';

void main() async {
  runApp(MyApp());
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider<RoomBloc>(
          create: (context) => RoomBloc(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.user.roles.any((role) => role.name == 'ADMIN')) {
                Navigator.of(context).pushReplacementNamed('/admin');
              } else if (state.user.roles.any((role) => role.name == 'USER')) {
                Navigator.of(context).pushReplacementNamed('/user');
              } else if (state.user.roles.any((role) => role.name == 'ASSO')) {
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
          '/user': (context) => const UserHomePage(title: ''),
          '/admin': (context) => const AdminHomePage(title: 'Admin Home Page'),
          '/asso': (context) => const UserHomePage(title: 'User Home Page'),
          '/not-found': (context) =>
              const NotFoundPage(title: 'Page not found'),
          '/admin/users': (context) => const CrudUserPage(),
        },
      ),
    );
  }
}
