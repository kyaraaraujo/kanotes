import 'package:flutter/material.dart';
import 'package:kanotes/extensions/buildcontext/loc.dart';
import 'package:kanotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.logout_button,
    content: context.loc.logout_dialog_prompt,
    optionBuilder: () => {
      context.loc.cancel: false,
      context.loc.logout_button: true,
    },
    // The return of showGenericDialog is optional <T?>
    // if the value is not defined, will return what defined at the end
    // as in this case: false.
  ).then((value) => value ?? false);
}
