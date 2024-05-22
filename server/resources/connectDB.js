const { default: mongoose } = require("mongoose");

const DB_URL =
  "mongodb+srv://andromj4:andro316a@mptictactoecluster.1vutbfx.mongodb.net/?retryWrites=true&w=majority&appName=MpTicTacToeCluster";

const connectDB = () => {
  mongoose
    .connect(DB_URL)
    .then(() => console.log("MongoDB connected successfully"))
    .catch((error) => console.error(error));
};
module.exports = connectDB;
