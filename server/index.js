const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const socket = require("socket.io");
const EVENT_NAMES = require("./resources/socket_events_names");
const { RoomModal } = require("./modals/room");
const connectDB = require("./resources/connectDB");

const PORT = process.env.PORT || 3000;

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
        room.isJoin = false;
        room = await room.save();
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

  socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await RoomModal.findById(roomId);
      let choice = room.turn.playerType; // x or o
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      io.to(roomId).emit("tapped", {
        index,
        room,
        choice,
      });
    } catch (error) {
      console.error(error);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      let room = await RoomModal.findById(roomId);
      let player = room.players.find(
        (player) => player.socketID == winnerSocketId
      );
      player.points += 1;
      room = await room.save();

      if (player.points >= room.maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointIncrease", player);
      }
    } catch (e) {
      console.log(e);
    }
  });
});

app.use(express.json());

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is started and running at port ${PORT}`);
  connectDB();
});
