import 'package:flutter/material.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:mp_tictactoe/responsive/responsive.dart';
import 'package:mp_tictactoe/widgets/custom_button.dart';
import 'package:mp_tictactoe/widgets/custom_text.dart';
import 'package:mp_tictactoe/widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = "/join-room";
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _gameIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.joinRoomSuccessListner(context);
    _socketMethods.errorOccurredListner(context);
    _socketMethods.updatePlayerStateListener(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gameIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                shadows: [
                  Shadow(blurRadius: 40, color: Colors.blue),
                ],
                fontSize: 70,
                text: "Join Room",
              ),
              SizedBox(height: size.height * 0.08),
              CustomTextField(
                hintText: "Enter your nick name",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: "Enter game Id",
                controller: _gameIdController,
              ),
              SizedBox(height: size.height * 0.045),
              CustomButton(
                  onTap: () => _socketMethods.joinRoom(
                      _nameController.text, _gameIdController.text),
                  text: "Join")
            ],
          ),
        ),
      ),
    );
  }
}
