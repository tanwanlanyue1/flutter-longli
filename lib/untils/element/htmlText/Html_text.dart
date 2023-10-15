import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:flutter/material.dart';

class HtmlText extends StatefulWidget {
  final Html;
  HtmlText({
    this.Html,
});
  @override
  _HtmlTextState createState() => _HtmlTextState();
}

class _HtmlTextState extends State<HtmlText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  HtmlWidget(
        widget.Html,
        onTapUrl: (url) => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('onTapUrl'),
            content: Text(url),
          ),
        ),
      ),
    );
  }
}
