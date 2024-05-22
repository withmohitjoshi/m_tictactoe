const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const socket = require("socket.io");
const EVENT_NAMES = require("./resources/socket_events_names");
const { RoomModal } = require("./modals/room");

const PORT = process.env.PORT || 3000;

const DB_URL =
  "mongodb+srv://andromj4:andro316a@mptictactoecluster.1vutbfx.mongodb.net/?retryWrites=true&w=majority&appName=MpTicTacToeCluster";

mongoose
  .connect(DB_URL)
  .then(() => console.log("MongoDB connected successfully"))
  .catch((error) => console.error(error));

const app = express();
const server = http.createServer(app);
const io = socket(server);

// socket connection and events here
io.on(EVENT_NAMES.connectionE, (socket) => {
  console.log("Socket get connected");

  // creating the room
  socket.on(EVENT_NAMES.createRoomE, async ({ nickname }) => {
    try {
      let room = new RoomModal();
      let player = {
        socketID: socket.id,
        nickname,
        playerType: "X",
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      const roomId = room._id.toString();
      socket.join(roomId);
      io.to(roomId).emit(EVENT_NAMES.createRoomSuccessE, room);
    } catch (error) {
      console.error(error);
    }
  });

  socket.on(EVENT_NAMES.joinRoomE, async ({ nickname, roomId }) => {
    try {
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit(EVENT_NAMES.errorOccurredE, {
          message: "Invalid Room ID!!!",
        });
        return;
      }
      let room = await RoomModal.findById(roomId);

      if (room.isJoin) {
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        room = await room.save();
        room.isJoin = false;
        io.to(roomId).emit(EVENT_NAMES.joinRoomSuccessE, room);
        io.to(roomId).emit(EVENT_NAMES.updatePlayersE, room.players);
        io.to(roomId).emit(EVENT_NAMES.updateRoomE, room);
      } else {
        socket.emit(EVENT_NAMES.errorOccurredE, {
          message: "Game is in progress, try again later.",
        });
        return;
      }
    } catch (error) {
      console.error(error);
    }
  });
});

app.use(express.json());

server.listen(PORT, "0.0.0.0", () =>
  console.log(`Server is started and running at port ${PORT}`)
);
