import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_navigation_button.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signUpWithEmailAndPassword(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Произошла ошибка при регистрации';
      if (e.code == 'weak-password') {
        message = 'Пароль слишком слабый.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Аккаунт с таким email уже существует.';
      } else if (e.code == 'invalid-email') {
        message = 'Некорректный формат email.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthTextField(
                    controller: _nameController,
                    labelText: 'Имя',
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Пароль',
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    isLoading: _isLoading,
                    onPressed: _register,
                    label: 'Зарегистрироваться',
                  ),
                  AuthNavigationButton(
                    isLoading: _isLoading,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    label: 'Уже есть аккаунт? Войти',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
