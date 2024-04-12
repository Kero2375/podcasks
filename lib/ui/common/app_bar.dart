import 'package:flutter/material.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/search/search_page.dart';

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
        overflow: TextOverflow.ellipsis,
        title ?? '',
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
