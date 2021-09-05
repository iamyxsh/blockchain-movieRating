const bytes32 = require("bytes32")

const movies = ["The Godfather", "The Dark Knigth Rises", "Fight Club"]

const moviesInByte32 = movies.map((m) => bytes32({ input: m }))

module.exports = moviesInByte32
