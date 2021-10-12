import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pop(),
      contentPadding: Pad.zero,
      dense: true,
      leading: Icon(
        Icons.arrow_back_ios_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      title: Text(title, style: Theme.of(context).textTheme.headline3),
    );
  }
}
