import 'package:baj_nemo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _biometricAvailable = false;
  bool _hasSavedAccount = false;

  static const String _identifierKey = 'baj_nemo_saved_identifier';
  static const String _passwordKey = 'baj_nemo_secure_password';

  static const Color _primaryColor = Color(0xFF123B5D);
  static const Color _accentColor = Color(0xFFB58A45);
  static const Color _backgroundColor = Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final identifier = prefs.getString(_identifierKey);
      final password = await _secureStorage.read(key: _passwordKey);

      if (!mounted) return;

      setState(() {
        if (identifier != null && identifier.isNotEmpty) {
          _identifierController.text = identifier;
        }

        _hasSavedAccount = identifier != null &&
            identifier.isNotEmpty &&
            password != null &&
            password.isNotEmpty;
      });
    } catch (_) {
      // L'application reste utilisable même si le stockage est indisponible.
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();

      if (!mounted) return;

      setState(() {
        _biometricAvailable = canCheck || supported;
      });
    } on PlatformException {
      if (!mounted) return;
      setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _saveAccount() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_identifierKey, identifier);

      await _secureStorage.write(key: _passwordKey, value: password);

      if (!mounted) return;
      setState(() => _hasSavedAccount = true);
    } catch (_) {
      // Ne pas bloquer la connexion si la mémorisation échoue.
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await AuthService().login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
      );

      await _saveAccount();

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connexion impossible : $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginBiometric() async {
    if (!_hasSavedAccount) {
      _showMessage('Connecte-toi une première fois pour activer cette option.');
      return;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authentifie-toi pour accéder à ton compte BAJ-NEMO.',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (!authenticated || !mounted) return;

      final identifier = _identifierController.text.trim().isNotEmpty
          ? _identifierController.text.trim()
          : (await SharedPreferences.getInstance()).getString(_identifierKey) ??
              '';

      final password = await _secureStorage.read(key: _passwordKey);

      if (identifier.isEmpty || password == null || password.isEmpty) {
        _showMessage(
          'Identifiants mémorisés introuvables. Connecte-toi à nouveau.',
        );
        return;
      }

      setState(() => _isLoading = true);

      await AuthService().login(identifier: identifier, password: password);

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } on PlatformException catch (e) {
      if (!mounted) return;
      _showMessage('Authentification indisponible : ${e.message ?? e.code}');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Connexion impossible : $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _forgetAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_identifierKey);
      await _secureStorage.delete(key: _passwordKey);

      if (!mounted) return;

      setState(() {
        _hasSavedAccount = false;
        _identifierController.clear();
        _passwordController.clear();
      });

      _showMessage('Compte mémorisé supprimé de cet appareil.');
    } catch (_) {
      if (mounted) {
        _showMessage('Impossible de supprimer le compte mémorisé.');
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF667085), fontSize: 14),
      prefixIcon: Icon(icon, color: _primaryColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E5EC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E5EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryColor, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Image.asset(
                      'assets/branding/BAJ_wordmark_transparent.png',
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'BAJ-NEMO',
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Bienvenue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connecte-toi à ton espace BAJ-NEMO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF667085), fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE7EBF0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _identifierController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            cursorColor: _primaryColor,
                            decoration: _inputDecoration(
                              label: 'Identifiant',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Saisis ton identifiant.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            cursorColor: _primaryColor,
                            decoration: _inputDecoration(
                              label: 'Mot de passe',
                              icon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                tooltip: _isPasswordVisible
                                    ? 'Masquer le mot de passe'
                                    : 'Afficher le mot de passe',
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF667085),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Saisis ton mot de passe.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    _primaryColor.withValues(alpha: 0.5),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          if (_biometricAvailable) ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _isLoading ? null : _loginBiometric,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primaryColor,
                                side: const BorderSide(color: _primaryColor),
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(
                                Icons.fingerprint_rounded,
                                size: 26,
                              ),
                              label: const Text(
                                'Connexion biométrique',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                          if (_hasSavedAccount) ...[
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: _isLoading ? null : _forgetAccount,
                              child: const Text(
                                'Oublier ce compte sur cet appareil',
                                style: TextStyle(
                                  color: Color(0xFF667085),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          'Tu n’as pas encore de compte ?',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Créer un compte',
                          style: TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Une expérience simple, sécurisée et élégante.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8A94A3), fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'BAJ-NEMO',
                      style: TextStyle(
                        color: _accentColor,
                        letterSpacing: 2,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
