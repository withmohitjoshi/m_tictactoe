const { default: mongoose } = require("mongoose");

const connectDB = () => {
  mongoose
    .connect(process.env.MONGODB_URI) // its must be in a .env file
    .then(() => console.log("MongoDB connected successfully"))
    .catch((error) => console.error(error));
};
module.exports = connectDB;
