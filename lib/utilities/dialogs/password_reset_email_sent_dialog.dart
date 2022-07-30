import 'package:flutter/cupertino.dart';
import 'package:kanotes/extensions/buildcontext/loc.dart';
import 'package:kanotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
