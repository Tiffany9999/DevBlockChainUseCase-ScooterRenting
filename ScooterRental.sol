
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  contract ScooterRental {

    address payable public cmu = payable(0x5122B8510F5c246e11a860463e90fC94E7080262); //Owner address[0]

    uint public rentalValue = 0.01 ether;  //Price of rental per day

    address[] public allowedAddresses = [0xDCEe6401D6eA30Bd6EE8d863DfC9296892D2B39d, 0xE057411810E2942Ebb4C93f4100e2f16383F59A4]; //Array of CMU student's addresses - address[1]&[2]

    struct Rental{
        uint256 endTime;
        address currentRenter;
    }

    Rental public currentRental; //Details of current rental (Customer)

    function rentCmuScooter() external payable{
        require(isStudent(msg.sender), "You are not a CMU student"); //Check if the customer is allowed
        require(address(this).balance >= rentalValue, "Insufficient balance to rent");
        require(msg.value == rentalValue, "Incorrect rental value");

        currentRental.endTime = block.timestamp + 1 days; //Assigning end time as 1 day from block creation
        currentRental.currentRenter = msg.sender; //Transfer ownership of scooter to customer for one day

        cmu.transfer(msg.value); //Transfer the rental price to cmu
    }

    function isStudent(address _address) public view returns (bool) {
        for (uint256 i = 0; i < allowedAddresses.length; i++) {
            if (allowedAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

}