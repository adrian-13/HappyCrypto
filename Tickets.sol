// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./ownable.sol";
import "./PriceConvertor.sol";

contract GameFactory is Ownable, PriceConvertor {

    struct Ticket {
        uint ticketId;
        uint value;
        address owner;
    }

    struct Game {
        uint id;
        bool isLimitedTickets;
        uint maxTickets;
        uint ticketPrice;
        bool active;
        Ticket[] ticketPool;
    }

    mapping(uint => Game) private games;
    uint private gameCount;
    uint private ticketCount;

    // Function to create a new game
    function createGame(bool _isLimitedTickets, uint _maxTickets, uint _ticketPrice) public onlyOwner {
        gameCount++;
        Game storage newGame = games[gameCount];
        require(newGame.active = true, "Game is over!");
        newGame.id = gameCount;
        newGame.isLimitedTickets = _isLimitedTickets;
        if (_isLimitedTickets == true) {
            require(_maxTickets > 0, "Invalid number of tickets.");
            newGame.maxTickets = _maxTickets;
        }
        newGame.ticketPrice = _ticketPrice;
        
    }
    // Function to buy a ticket
    function buyTicket(uint gameId) public payable {
        ticketCount++;
        require(gameId > 0 && gameId <= gameCount, "Invalid game index.") ;

        Game storage game = games[gameId];

        require(game.active, "Game is not active");
        require(!game.isLimitedTickets || game.ticketPool.length < game.maxTickets, "Maximum number of tickets reached");
        require(msg.value >= getEthAmount(game.ticketPrice), "Didn't send enought!");

        uint ticketId = game.ticketPool.length + 1;
        Ticket memory newTicket = Ticket(ticketId, game.ticketPrice, msg.sender);
        newTicket.ticketId = ticketCount;
        game.ticketPool.push(newTicket);
        
    }

    // Function to get the number of created games
    function getNumberOfGames() public view onlyOwner returns (uint) {
        return gameCount;
    }

    // Function to get game information based on its index in the array
    function getGame(uint gameId) public view onlyOwner returns (bool, uint, uint, bool) {
        require(gameId > 0 && gameId <= gameCount, "Invalid game index");
    
        Game memory game = games[gameId];
    
        bool isLimitedTickets = game.isLimitedTickets;
        uint maxTickets = game.maxTickets;
        uint ticketPrice = game.ticketPrice;
        bool active = game.active;
    
        return (isLimitedTickets, maxTickets, ticketPrice, active);
    }

    // Function to get ticket information based on game and its index
    function getTicket(uint gameId, uint ticketId) public view returns (uint, uint, address) {
        require(gameId > 0 && gameId <= gameCount, "Invalid game index");
        require(ticketId > 0 && ticketId <= games[gameId].ticketPool.length, "Invalid ticket index");
    
        Ticket memory ticket = games[gameId].ticketPool[ticketId - 1];
    
        uint ticketValue = ticket.value;
        address ticketOwner = ticket.owner;
    
        return (ticketValue, ticketId, ticketOwner);
    }
}
