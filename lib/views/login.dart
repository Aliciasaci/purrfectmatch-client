import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/views/user/user_home_page.dart';
import '../blocs/auth_bloc.dart';
import 'register.dart';

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

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => const UserHomePage(title: '')),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connexion réussie!')),
              );
            }
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.amberAccent, Colors.orange],
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
                            const Text(
                              'Connexion',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Veuillez entrer une adresse email valide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Mot de passe',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        LoginRequested(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Connexion'),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Pas encore de compte ? Inscris-toi',
                                    style: TextStyle(
                                      color: Colors.blue,
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
            ),
          );
        },
      ),
    );
  }
}
