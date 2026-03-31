import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: popupMenuShape(context),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              message ?? context.l10n!.pleaseWait,
              style: textStyleBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showLoading(BuildContext context, {String? message}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoadingDialog(message: message),
  );
  // Ensure the dialog is built before proceeding with heavy work
  await Future.delayed(Duration.zero);
}

void hideLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
