import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/responsive/responsive.dart';
import 'package:mp_tictactoe/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({super.key});

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;

  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(
      text:
          Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'],
    );
  }

  @override
  void dispose() {
    roomIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Waiting for a Player to join"),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: "",
            controller: roomIdController,
            isReadOnly: true,
          )
        ],
      ),
    );
  }
}
