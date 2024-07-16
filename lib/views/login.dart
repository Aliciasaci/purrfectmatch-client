import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/services/auth_service.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/auth/auth_bloc.dart';
import 'register.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';
import '../locale_provider.dart';
import '../views/register.dart';
import '../blocs/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  static String get baseUrl => kIsWeb ? dotenv.env['WEB_BASE_URL']! : dotenv.env['MOBILE_BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserHomePage(title: '')),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.loginSuccessful)),
              );
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/paw.png'),
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.login,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange[100]!,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_circle_rounded,
                                      color: Colors.orange[100]),
                                  border: InputBorder.none,
                                  labelText: AppLocalizations.of(context)!.email,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.enterEmail;
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return AppLocalizations.of(context)!.invalidEmail;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange[100]!,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.password,
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock, color: Colors.orange[100]),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.enterPassword;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orange[100],
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<AuthBloc>(context).add(
                                          LoginRequested(
                                            email: _emailController.text,
                                            password:
                                            _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context)!.login),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<AuthBloc>(context).add(
                                      GoogleLoginRequested(),
                                    );
                                  },
                                  icon: const CircleAvatar(
                                    backgroundImage: AssetImage('assets/google_logo.png'),
                                    radius: 20,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const RegisterPage()),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.register,
                                    style: TextStyle(
                                      color: Colors.orange[200],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      await AuthService().handleGoogleSignIn();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la connexion avec Google')),
      );
    }
  }
}
