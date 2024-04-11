import 'package:flutter/material.dart';
import 'package:ppp2/ui/pages/search/search_page.dart';

AppBar mainAppBar(
  BuildContext context, {
  String? title,
  bool cast = false,
}) {
  return AppBar(
    leading: cast
        ? IconButton(
            onPressed: () {}, // todo: cast
            icon: const Icon(Icons.cast),
          )
        : null,
    title: Center(child: Text(title ?? '')),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, SearchPage.route);
        },
        icon: const Icon(Icons.search),
      )
    ],
  );
}
