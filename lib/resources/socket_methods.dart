import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/socket_events_name.dart';
import 'package:mp_tictactoe/resources/socket_client.dart';
import 'package:mp_tictactoe/screens/game_screen.dart';
import 'package:mp_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket;

  // emits
  createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient?.emit(createRoomE, {"nickname": nickname});
    }
  }

  joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient?.emit(
        joinRoomE,
        {"nickname": nickname, "roomId": roomId},
      );
    }
  }

  // listeners
  void createRoomSuccessListner(BuildContext context) {
    _socketClient?.on(createRoomSuccessE, (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      showSnakbar(context, "Room ID is: ${room['_id']}");
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListner(BuildContext context) {
    _socketClient?.on(joinRoomSuccessE, (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccurredListner(BuildContext context) {
    _socketClient?.on(errorOccurredE, (data) {
      showSnakbar(context, data['message']);
    });
  }

  void updatePlayerStateListener(BuildContext context) {
    _socketClient?.on(updatePlayersE, (playersData) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer1(playersData[0]);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer2(playersData[1]);
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient?.on(updateRoomE, (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }
}
