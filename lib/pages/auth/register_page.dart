import 'package:baj_nemo/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _accepted = false;
  bool _professional = false;

  static const Color _primaryColor = Color(0xFF123B5D);
  static const Color _accentColor = Color(0xFFB58A45);
  static const Color _backgroundColor = Color(0xFFF5F7FA);

  static const String _termsVersion = '1.0';

  static const String _termsText = '''
CONDITIONS D’UTILISATION DE BAJ-NEMO

1. INFORMATIONS PERSONNELLES

L’utilisateur s’engage à fournir des informations exactes lors de la création de son compte.

2. SÉCURITÉ DU COMPTE

L’utilisateur est responsable de la confidentialité de ses identifiants et de la sécurité de son compte.

3. UTILISATION DE L’APPLICATION

L’application BAJ-NEMO doit être utilisée de manière responsable et conformément aux lois applicables.

4. RESPONSABILITÉ DE L’UTILISATEUR

L’utilisateur s’engage à ne pas utiliser l’application à des fins frauduleuses ou illicites.

5. ACCEPTATION DES CONDITIONS

En cochant la case d’acceptation, l’utilisateur confirme avoir lu et accepté les présentes conditions.

Version : 1.0
''';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_accepted) {
      _showMessage(
        'Tu dois accepter les conditions d’utilisation pour continuer.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await AuthService().register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
        professional: _professional,
        termsVersion: _termsVersion,
      );

      // Connecte l’utilisateur après la création de son compte local.
      await AuthService().login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage('Inscription impossible : $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF667085),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: _primaryColor,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE0E5EC),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE0E5EC),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: _primaryColor,
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      cursorColor: _primaryColor,
      decoration: _inputDecoration(
        label: label,
        icon: icon,
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le champ $label est obligatoire.';
            }
            return null;
          },
    );
  }

  void _showTerms() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.78,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Conditions d’utilisation',
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close_rounded),
                        color: _primaryColor,
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _termsText,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Fermer',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: _primaryColor,
        elevation: 0,
        title: const Text(
          'Créer un compte',
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/branding/BAJ_wordmark_transparent.png',
                      height: 78,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'BAJ-NEMO',
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rejoins BAJ-NEMO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crée ton compte pour accéder à ton espace.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE7EBF0),
                      ),
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
                          _buildTextField(
                            controller: _firstNameController,
                            label: 'Prénom',
                            icon: Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _lastNameController,
                            label: 'Nom',
                            icon: Icons.badge_outlined,
                          ),

                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _identifierController,
                            label: 'Identifiant',
                            icon: Icons.account_circle_outlined,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Saisis un identifiant.';
                              }
                              if (value.trim().length < 3) {
                                return 'Au moins 3 caractères sont requis.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Type de compte
                          const Text(
                            'Type de compte',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: _AccountTypeCard(
                                  title: 'Particulier',
                                  subtitle: 'Compte personnel',
                                  icon: Icons.person_rounded,
                                  selected: !_professional,
                                  onTap: () {
                                    setState(() {
                                      _professional = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AccountTypeCard(
                                  title: 'Professionnel',
                                  subtitle: 'Compte activité',
                                  icon: Icons.business_center_rounded,
                                  selected: _professional,
                                  onTap: () {
                                    setState(() {
                                      _professional = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            cursorColor: _primaryColor,
                            decoration: _inputDecoration(
                              label: 'Mot de passe',
                              icon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
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
                                return 'Saisis un mot de passe.';
                              }
                              if (value.length < 8) {
                                return 'Au moins 8 caractères sont requis.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _register(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            cursorColor: _primaryColor,
                            decoration: _inputDecoration(
                              label: 'Confirmer le mot de passe',
                              icon: Icons.lock_reset_rounded,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF667085),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirme ton mot de passe.';
                              }
                              if (value != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 22),

                          // Conditions locales : aucune API requise.
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE7EBF0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Conditions d’utilisation',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Consulte les conditions avant de créer ton compte.',
                                  style: TextStyle(
                                    color: Color(0xFF667085),
                                    fontSize: 13,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: _showTerms,
                                    child: const Text(
                                      'Lire toutes les conditions',
                                      style: TextStyle(
                                        color: _primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor: _primaryColor,
                                  value: _accepted,
                                  onChanged: (value) {
                                    setState(() {
                                      _accepted = value ?? false;
                                    });
                                  },
                                  title: const Text(
                                    'J’accepte les conditions d’utilisation.',
                                    style: TextStyle(
                                      color: Color(0xFF344054),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
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
                                      height: 23,
                                      width: 23,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Créer mon compte',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                      ),
                      label: const Text('Retour à la connexion'),
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const Color _primaryColor = Color(0xFF123B5D);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEAF1F7) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? _primaryColor : const Color(0xFFE0E5EC),
              width: selected ? 1.7 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: _primaryColor,
                size: 27,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
