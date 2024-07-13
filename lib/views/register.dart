import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressRueController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthService authService = AuthService();
      await authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _addressRueController.text,
        _cpController.text,
        _villeController.text,
      );

      if (AuthService.authToken != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage(title: '')),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.registerSuccessful)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.tokenRetrievalFailed)),
        );
      }
    } catch (e) {
      String errorMessage = AppLocalizations.of(context)!.registrationFailed;
      if (e is AuthException) {
        errorMessage = e.message;
      }
      print("Exception pendant l'inscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.amberAccent[100]!, Colors.orange[400]!],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    margin: const EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo.png'),
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.registerPage,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.name,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterEmail;
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return AppLocalizations.of(context)!.invalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                border: const OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterPassword;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _addressRueController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.addressRue,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterAddress;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _cpController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.postalCode,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterPostalCode;
                                }
                                if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                                  return AppLocalizations.of(context)!.invalidPostalCode;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _villeController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.city,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.enterCity;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _register,
                              child: Text(AppLocalizations.of(context)!.registerPage),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.alreadyHaveAccount,
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (localeProvider.locale == const Locale('en')) {
                  localeProvider.setLocale(const Locale('fr'));
                } else {
                  localeProvider.setLocale(const Locale('en'));
                }
              },
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(
                  localeProvider.locale == const Locale('fr')
                      ? 'assets/images/flag_fr.png'
                      : 'assets/images/flag_uk.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
