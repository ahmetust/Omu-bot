import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableText extends StatelessWidget {
  final String text;

  const ClickableText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r'https://\S+',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = urlRegExp.allMatches(text);

    if (matches.isEmpty) {
      return SelectableText(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      );
    }

    List<TextSpan> spans = [];
    int start = 0;

    for (RegExpMatch match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ));
      }

      final String url = match.group(0) ?? '';
      final Uri uri = Uri.parse(url);
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
            decorationThickness: 1.5,
            height: 1.2, // Metin ile alt çizgi arasındaki mesafe
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Could not launch $url';
              }
            },
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return SelectableText.rich(
      TextSpan(
        children: spans,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
