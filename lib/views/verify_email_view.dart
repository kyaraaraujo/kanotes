import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanotes/extensions/buildcontext/loc.dart';
import 'package:kanotes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.verify_email)),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(context.loc.verify_email_view_prompt),
          ),
          TextButton(
            child: Text(context.loc.verify_email_send_email_verification),
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
          ),
          TextButton(
            child: Text(context.loc.restart),
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
          )
        ]),
      ),
    );
  }
}
