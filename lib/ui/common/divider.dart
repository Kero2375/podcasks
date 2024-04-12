import 'package:flutter/material.dart';

Widget divider(BuildContext context) => Container(
      color: Theme.of(context).colorScheme.onBackground.withOpacity(.1),
      width: double.infinity,
      height: 1,
    );
