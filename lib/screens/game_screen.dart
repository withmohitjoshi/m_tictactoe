import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/views/waiting_lobby.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  static String routeName = "/game";
  final String? id;
  const GameScreen({super.key, this.id});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return Scaffold(
      body: roomDataProvider.roomData['isJoin']
          ? const WaitingLobby()
          : const Center(
              child: Text("game screen"),
            ),
    );
  }
}
