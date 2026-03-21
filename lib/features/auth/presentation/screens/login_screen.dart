import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_tokens.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  var _register = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = ref.read(authProvider.notifier);
    FocusScope.of(context).unfocus();
    if (_register) {
      await auth.register(_email.text.trim(), _password.text, _name.text.trim());
    } else {
      await auth.login(_email.text.trim(), _password.text);
    }
    if (!mounted) return;
    final st = ref.read(authProvider);
    if (st.hasError) {
      final e = st.error;
      final msg = e is ApiException ? e.message : '$e';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    final s = st.valueOrNull;
    if (s != null && s.isAuthenticated) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authAsync = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _register ? 'Criar conta' : 'Entrar',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Conectado à API Biblia Reader (VPS).',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            if (_register) ...[
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.s12),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.s24),
            FilledButton(
              onPressed: authAsync.isLoading ? null : _submit,
              child: authAsync.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_register ? 'Registrar' : 'Entrar'),
            ),
            TextButton(
              onPressed: authAsync.isLoading
                  ? null
                  : () => setState(() {
                        _register = !_register;
                      }),
              child: Text(_register ? 'Já tenho conta' : 'Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
