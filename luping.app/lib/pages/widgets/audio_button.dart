import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AudioButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.volume_up, color: Colors.green),
      onPressed: onPressed,
    );
  }
}
