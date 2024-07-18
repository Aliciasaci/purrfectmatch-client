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
          MaterialPageRoute(
              builder: (context) => const UserHomePage(title: '')),
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
                          AppLocalizations.of(context)!.registerPage,
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
                            controller: _nameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.account_circle_rounded,
                                  color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.name,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.enterName;
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
                            controller: _emailController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email, color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.email,
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
                              icon: Icon(Icons.lock, color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.password,
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange[100]!,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _addressRueController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.home, color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.addressRue,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.enterAddress;
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
                            controller: _cpController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.location_on, color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.postalCode,
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
                            controller: _villeController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.location_city, color: Colors.orange[100]),
                              border: InputBorder.none,
                              labelText: AppLocalizations.of(context)!.city,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.enterCity;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange[100],
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: _register,
                            child: Text(AppLocalizations.of(context)!.registerPage),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.alreadyHaveAccount,
                            style: TextStyle(
                              color: Colors.orange[200],
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
        ],
      ),
    );
  }
}
