// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./ownable.sol";

contract TimeConvertor is Ownable {

    struct DateTime {
        uint day;
        uint month;
        uint year;
        uint hour;
        uint minute;
    }

    DateTime public startDateTime;
    DateTime public endDateTime;

    // Funkcia na rozklad časovej značky na dátum a čas
    function parseDateTime(uint timestamp) public pure returns (uint day, uint month, uint year, uint hour, uint minute) {
        day = timestamp / 10000000000;       // Extrahovanie dňa
        month = (timestamp / 100000000) % 100;   // Extrahovanie mesiaca
        year = (timestamp / 1000000) % 10000;     // Extrahovanie roku
        hour = (timestamp / 10000) % 100;        // Extrahovanie hodín
        minute = (timestamp / 100) % 100;        // Extrahovanie minút
    }

    // Funkcia na prevod dátumu a času na časovú značku
    function getTimestamp(uint year, uint month, uint day, uint hour, uint minute) public pure returns (uint timestamp) {
        timestamp = (year * 10000000000) + (month * 100000000) + (day * 1000000) + (hour * 10000) + (minute * 100);
    }

    function setStartDateTime(uint _startDateTime) public onlyOwner {
       (startDateTime.day, startDateTime.month, startDateTime.year, startDateTime.hour, startDateTime.minute) = parseDateTime(_startDateTime);
    }

    function setEndDateTime(uint _endDateTime) public onlyOwner {
        (endDateTime.day, endDateTime.month, endDateTime.year, endDateTime.hour, endDateTime.minute) = parseDateTime(_endDateTime);
    }  
}
