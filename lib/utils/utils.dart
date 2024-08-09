import 'package:flutter/material.dart';
import 'package:mp_tictactoe/resources/game_methods.dart';

void showSnakbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}

const IP = "***.***.**.**";

void showGameDialog(BuildContext context, String text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                GameMethods().clearBoard(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Play Again',
              ),
            ),
          ],
        );
      });
}
