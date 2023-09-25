import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: SizedBox(
        child: Form(
          child: Column(
            
            children: [
              const Text(
                  "We've send you an email verification. please open it to verify your account",
                  
                  ),
              const Text(
                  "If you haven't receive a verification email yet, press the button below"),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text('Send Email verification'),
              ),
              TextButton(
                  onPressed: () async {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: const Text('Restart'))
            ],
          ),
        ),
      ),
    );
  }
}
