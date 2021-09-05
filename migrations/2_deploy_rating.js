const movies = require("../configs/MoviesName")

const Ratings = artifacts.require("Ratings")

module.exports = function (deployer) {
	deployer.deploy(Ratings, movies)
}
