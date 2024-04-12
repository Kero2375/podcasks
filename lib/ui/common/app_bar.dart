import 'package:flutter/material.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/search/search_page.dart';

AppBar mainAppBar(
  BuildContext context, {
  String? title,
  bool cast = false,
}) {
  return AppBar(
    leading: cast
        ? IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Googlecast & Airplay are still WIP'),
                duration: Duration(seconds: 2),
              ));
            }, // todo: cast
            icon: const Icon(Icons.cast),
          )
        : null,
    title: Center(
      child: Text(
        overflow: TextOverflow.ellipsis,
        title ?? '',
        style: textStyleTitle,
      ),
    ),
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
