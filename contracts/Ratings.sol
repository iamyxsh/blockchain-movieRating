// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.9.0;

contract Ratings {
    uint public numOfMovies = 0;
    string public accAddress;

    struct Movie {
        uint id; 
        string name;
        uint rating; 
        uint numOfRatings;
    }
     
    struct RatingByUser {
        uint movieId;
        uint rating;
    }

    // abcd = > [{uint movieId; uint rating;}]

    mapping(uint => Movie) public movies;
    mapping(string => RatingByUser[]) public ratingByUsers;
    Movie public mov;
    RatingByUser public rat;
    RatingByUser[] public  userArray;

    constructor(bytes32[] memory _movies) public {
        createMovies(_movies);
        setAccount("abcd");
    }



    function createMovies(bytes32[] memory _movies) public payable {
        uint _movieLen = _movies.length;
        for(uint i=0; i<_movieLen; i++) {
             movies[i] = Movie(i, toString(_movies[i]), 0, 0);
             numOfMovies++;
        }
    }

    function setAccount(string memory _add) public {
        accAddress = _add;
    }

    function getRating(string memory userId) public view returns(RatingByUser[] memory ratingByUsersArr) {
        return ratingByUsers[userId];
    }

    function addRating(uint _rating, uint _movieId) public {
        RatingByUser[] storage _ratingByUserArr  = ratingByUsers[accAddress];
        // userArray = _ratingByUserArray;
        Movie memory _movie = movies[_movieId];

        if( _ratingByUserArr.length == 0){
          for(uint i=0; i < numOfMovies; i++) {
          ratingByUsers[accAddress].push(RatingByUser(i, 0));
          }
        }

        RatingByUser memory _ratingByUser = _ratingByUserArr[_movieId];

        if(_ratingByUser.rating == 0) {
        _movie.numOfRatings = _movie.numOfRatings + 1;
        _movie.rating = calc(_movie.rating + (_rating * 100),_movie.numOfRatings);
        } else {
            uint _prevRating = _ratingByUser.rating;
            uint _totalRating = _movie.numOfRatings * _movie.rating;
            _totalRating = _totalRating - (_prevRating) + (_rating * 100);
            _movie.rating = _totalRating/_movie.numOfRatings;
        }

        ratingByUsers[accAddress][_movieId] = RatingByUser(_movieId, _rating * 100);
        movies[_movieId] = _movie;
        
        mov = _movie;
        rat = _ratingByUser;
    }

    // take bytes32 and return a string
function toString(bytes32 _data)
  pure
  private
  returns (string memory)
{
  // create new bytes with a length of 32
  // needs to be bytes type rather than bytes32 in order to be writeable
  bytes memory _bytesContainer = new bytes(32);
  // uint to keep track of actual character length of string
  // bytes32 is always 32 characters long the string may be shorter
  uint256 _charCount = 0;
  // loop through every element in bytes32
  for (uint256 _bytesCounter = 0; _bytesCounter < 32; _bytesCounter++) {
    /*
    TLDR: takes a single character from bytes based on counter
    convert bytes32 data to uint in order to increase the number enough to
    shift bytes further left while pushing out leftmost bytes
    then convert uint256 data back to bytes32
    then convert to bytes1 where everything but the leftmost hex value (byte)
    is cutoff leaving only the leftmost byte
    */
    bytes1 _char = bytes1(bytes32(uint256(_data) * 2 ** (8 * _bytesCounter)));
    // if the character is not empty
    if (_char != 0) {
      // add to bytes representing string
      _bytesContainer[_charCount] = _char;
      // increment count so we know length later
      _charCount++;
    }
  }

  // create dynamically sized bytes array to use for trimming
  bytes memory _bytesContainerTrimmed = new bytes(_charCount);

  // loop through for character length of string
  for (uint256 _charCounter = 0; _charCounter < _charCount; _charCounter++) {
    // add each character to trimmed bytes container, leaving out extra
    _bytesContainerTrimmed[_charCounter] = _bytesContainer[_charCounter];
  }

  // return correct length string with no padding
  return string(_bytesContainerTrimmed);
}

function calc(uint a, uint b) private pure returns ( uint)  {

    //  return a*(10**precision)/b;
    return a/b;
 }

}