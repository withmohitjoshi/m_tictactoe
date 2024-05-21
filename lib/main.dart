import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';
import 'package:mp_tictactoe/screens/game_screen.dart';
import 'package:mp_tictactoe/screens/join_room_screen.dart';
import 'package:mp_tictactoe/screens/main_menu_screen.dart';
import 'package:mp_tictactoe/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoomDataProvider(),
      child: SafeArea(
        child: MaterialApp(
          routes: {
            MainMenuScreen.routeName: (context) => const MainMenuScreen(),
            JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
            CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
            GameScreen.routeName: (context) => const GameScreen(),
          },
          initialRoute: MainMenuScreen.routeName,
          title: 'Flutter Demo',
          theme: ThemeData.dark(useMaterial3: !true).copyWith(
            scaffoldBackgroundColor: bgColor,
          ),
          home: const MainMenuScreen(),
        ),
      ),
    );
  }
}
