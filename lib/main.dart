
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8CB83);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GuildQuest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171329),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB89B55),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF241C40),
          foregroundColor: gold,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: gold),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB89B55),
            foregroundColor: const Color(0xFF171329),
          ),
        ),
      ),
      home: const SignupPage(),
    );
  }
}

// The AI service uses the instructor's endpoint when configured.
// Until then, the deterministic mock is used.
class GuildTipService {
  static const String? endpoint = null;

  static Future<String> getTip() async {
    if (endpoint == null) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return 'Mock tip: Use a unique password of at least 12 characters. '
          'Combine words with numbers or symbols, and never reuse a password '
          'from another account.';
    }

    final response = await http
        .post(
          Uri.parse(endpoint!),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'task': 'signup_tip',
            'topic': 'password_help',
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('The guild service is unavailable.');
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic> ||
        data['tip'] is! String ||
        (data['tip'] as String).trim().isEmpty) {
      throw Exception('The guild service returned an invalid tip.');
    }

    return (data['tip'] as String).trim();
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loadingTip = false;
  String? _tip;
  String? _tipError;

  static const gold = Color(0xFFE8CB83);
  static const purple = Color(0xFF241C40);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _getGuildTip() async {
    setState(() {
      _loadingTip = true;
      _tip = null;
      _tipError = null;
    });

    try {
      final tip = await GuildTipService.getTip().timeout(
        const Duration(seconds: 10),
      );

      if (!mounted) return;

      setState(() {
        _tip = tip.length > 240 ? tip.substring(0, 240) : tip;
        _loadingTip = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _tipError =
            'The Guildmaster is unavailable right now. Please try again.';
        _loadingTip = false;
      });
    }
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome, ${_nameController.text.trim()}! '
            'Your demo signup passed validation.',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GUILDQUEST',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: purple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.shield,
                  size: 64,
                  color: gold,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Join the Guild',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your next adventure begins here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Character Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your character name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Account Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') ||
                        !value.substring(value.indexOf('@') + 1).contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Guild Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _signUp,
                  icon: const Icon(Icons.sports_martial_arts),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'JOIN THE GUILD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Divider(color: gold),
                const SizedBox(height: 12),
                const Text(
                  'GUILDMASTER\'S ADVICE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Need advice before your journey? Ask the Guildmaster '
                  'for a password tip.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _loadingTip ? null : _getGuildTip,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(
                    _loadingTip ? 'Consulting the Guildmaster...' :
                        'Get a Signup Tip',
                  ),
                ),
                if (_loadingTip) ...[
                  const SizedBox(height: 16),
                  const Center(
                    child: CircularProgressIndicator(color: gold),
                  ),
                ],
                if (_tip != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: purple,
                      border: Border.all(color: gold),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MOCK GUILDMASTER TIP',
                          style: TextStyle(
                            color: gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_tip!),
                        const SizedBox(height: 8),
                        const Text(
                          'Demonstration mock; no live AI model was called. '
                          'This advice does not validate your signup.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_tipError != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _tipError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  TextButton(
                    onPressed: _loadingTip ? null : _getGuildTip,
                    child: const Text('Try Again'),
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Demo only. No account is created and no personal '
                  'form information is sent to the tip service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
