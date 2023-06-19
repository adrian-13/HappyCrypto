// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./ownable.sol";
import "./GameFactory.sol";

contract Tickets is Ownable, GameFactory {
    // udalosť je emitovaná pri zakúpení lístka
    event TicketPurchased(
        uint256 indexed ticketId,
        address indexed owner,
        uint256 value
    );

    struct Ticket {
        uint256 ticketId; // Jedinečný identifikátor lístka
        address owner; // Adresa vlastníka lístka
        uint256 value; // Hodnota zakúpeného lístka
    }

    Ticket[] private ticketPool;
    uint256 private ticketCounter;

    constructor() {
        ticketCounter = 1; // Začiatočná hodnota inkrementálneho čítača
    }

    // Priradí nový lístok do poolu lístkov
    function buyTicket() public payable {
        require(msg.value > 0, "You need to send some ether to buy a ticket.");

        Ticket memory newTicket = Ticket(ticketCounter, msg.sender, msg.value);
        ticketPool.push(newTicket);

        // umožňuje emitovať udalosť so správnymi parametrami počas vykonávania funkcie
        emit TicketPurchased(ticketCounter, msg.sender, msg.value);

        ticketCounter++; // Inkrementujeme hodnotu inkrementálneho čítača pre ďalší lístok
    }

    // Funkcia, ktorá vráti celkový počet kúpených lístkov
    function getNumberOfTickets() public view onlyOwner returns (uint) {
        return ticketPool.length;
    }

    // Funkcia, ktorá vráti jedinečný identifikátor lístka pre daný index
    function getTicketId(uint index) public view onlyOwner returns (uint256) {
        require(index < ticketPool.length, "Invalid ticket index.");
        return ticketPool[index].ticketId;
    }

    function getAllTickets() public view onlyOwner returns (Ticket[] memory) {
        return ticketPool;
    }
}
