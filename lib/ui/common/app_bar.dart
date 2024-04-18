import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';

AppBar mainAppBar(
  BuildContext context, {
  String? title,
  Widget? actions,
  Widget? leading,
}) {
  return AppBar(
    leading: leading,
    title: Center(
      child: Text(
        title ?? '',
        overflow: TextOverflow.ellipsis,
        style: textStyleTitle,
      ),
    ),
    actions: [
      actions ??
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.route);
            },
            icon: const Icon(Icons.search),
          )
    ],
  );
}
