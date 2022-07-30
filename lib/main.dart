import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanotes/constants/routes.dart';
import 'package:kanotes/extensions/buildcontext/loc.dart';
import 'package:kanotes/helpers/loading/loading_screen.dart';
import 'package:kanotes/services/auth/bloc/auth_bloc.dart';
import 'package:kanotes/services/auth/bloc/auth_event.dart';
import 'package:kanotes/services/auth/bloc/auth_state.dart';
import 'package:kanotes/services/auth/firebase_auth_provider.dart';
import 'package:kanotes/views/forgot_password_view.dart';
import 'package:kanotes/views/login_view.dart';
import 'package:kanotes/views/register_view.dart';
import 'package:kanotes/views/verify_email_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'views/notes/create_update_note_view.dart';
import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    MaterialApp(
      title: 'Kanotes',
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? context.loc.loading_screen,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
