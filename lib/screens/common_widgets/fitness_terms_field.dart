import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FitnessTermsField extends StatefulWidget {
  final String termsText;
  final String url;
  final void Function(bool?) onChanged;
  const FitnessTermsField({
    super.key,
    required this.termsText,
    required this.onChanged,
    required this.url,
  });
  @override
  // ignore: library_private_types_in_public_api
  _FitnessTermsFieldState createState() => _FitnessTermsFieldState();
}

class _FitnessTermsFieldState extends State<FitnessTermsField> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
                widget.onChanged(value);
              },
            ),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(widget.url));
              },
              child: Text(widget.termsText),
            ),
          ],
        ));
  }
}
