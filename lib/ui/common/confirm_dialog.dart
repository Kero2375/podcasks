import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? emoji;
  final String actionText;
  final Icon actionIcon;
  final Function()? onTap;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.emoji,
    required this.actionText,
    required this.actionIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: textStyleHeader),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: textStyleBody),
          if (emoji != null) ...[
            const SizedBox(height: 8),
            Text(
              emoji!,
              style: textStyleBody,
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: buttonStyle,
          child: Text(context.l10n!.cancel),
        ),
        FilledButton.icon(
          icon: actionIcon,
          onPressed: () {
            onTap?.call();
            Navigator.pop(context);
          },
          style: buttonStyle,
          label: Text(actionText),
        ),
      ],
    );
  }
}
