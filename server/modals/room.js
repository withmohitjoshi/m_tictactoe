const { Schema, model } = require("mongoose");
const { playerSchema } = require("./playerSchema");

const roomSchema = new Schema({
  occupancy: {
    type: Number,
    default: 2,
  },
  maxRounds: {
    type: Number,
    default: 6,
  },
  currentRound: {
    required: true,
    type: Number,
    default: 1,
  },
  players: [playerSchema],
  isJoin: {
    type: Boolean,
    default: true,
  },
  turn: playerSchema,
  turnIndex: {
    type: Number,
    default: 0,
  },
});


const RoomModal = model("Room", roomSchema);

module.exports = {
    RoomModal,
};
