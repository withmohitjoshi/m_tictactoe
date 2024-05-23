import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/game_methods.dart';
import 'package:mp_tictactoe/resources/socket_events_name.dart';
import 'package:mp_tictactoe/resources/socket_client.dart';
import 'package:mp_tictactoe/screens/game_screen.dart';
import 'package:mp_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket;

  Socket? get socketClient => _socketClient;

  // emits
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient?.emit(createRoomE, {"nickname": nickname});
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient?.emit(
        joinRoomE,
        {"nickname": nickname, "roomId": roomId},
      );
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient?.emit(tapE, {
        "index": index,
        'roomId': roomId,
      });
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

  void tappedListener(BuildContext context) {
    _socketClient?.on(tappedE, (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      roomDataProvider.updateDisplayElements(data['index'], data['choice']);
      roomDataProvider.updateRoomData(data['room']);
      // check for the winner
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient?.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient?.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}
