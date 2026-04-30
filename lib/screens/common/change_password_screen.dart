import 'package:cabkaro/controllers/auth_check_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────────
// Change Password Screen
// ─────────────────────────────────────────────

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureRetype = true;

  @override
  void dispose() {
    context
        .read<AuthCheckController>()
        .currentPasswordController
        .dispose();
    context.read<AuthCheckController>().newPasswordController.dispose();
    context
        .read<AuthCheckController>()
        .confirmPasswordController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C100),
        foregroundColor: const Color(0xFF2D2F35),
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D2F35),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: context.
          read<AuthCheckController>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // Field label + field
              _buildFieldLabel('Current Password'),
              const SizedBox(height: 6),
              _PasswordField(
                controller: context
                    .read<AuthCheckController>()
                    .currentPasswordController,
                hint: 'Enter your current password',
                obscure: _obscureCurrent,
                onToggle: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (val) {
                  if (val == null || val.isEmpty){
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFieldLabel('New Password'),
              const SizedBox(height: 6),
              _PasswordField(
                controller: context
                    .read<AuthCheckController>()
                    .newPasswordController,
                hint: 'Enter your new password',
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (val.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(val)) {
                    return 'Must contain at least one number';
                  }
                  if (val ==
                      context
                          .read<AuthCheckController>()
                          .currentPasswordController
                          .text) {
                    return 'New password must differ from current';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFieldLabel('Retype New Password'),
              const SizedBox(height: 6),
              _PasswordField(
                controller: context
                    .read<AuthCheckController>()
                    .confirmPasswordController,
                hint: 'Confirm your new password',
                obscure: _obscureRetype,
                onToggle: () =>
                    setState(() => _obscureRetype = !_obscureRetype),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (val !=
                      context
                          .read<AuthCheckController>()
                          .newPasswordController
                          .text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 36),

              // Submit Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
<<<<<<< HEAD
                  onPressed: () {
                    if (context
                        .read<AuthCheckController>()
                        .formKey
                        .currentState!
                        .validate()) {
                      context.read<AuthCheckController>().changePassword(
                        context,
                      );
                    }
                  },
=======
                  onPressed: null,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Update Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF2D2F35),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Static field label above each input ──
  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D2F35),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reusable Password Field Widget
// ─────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint, // ← hint instead of label
    required this.obscure,
    required this.onToggle,
    required this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF2D2F35)),
      decoration: InputDecoration(
        // ✅ hintText instead of labelText — no floating label
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF2D2F35),
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF6A6A6A),
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8C100), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
