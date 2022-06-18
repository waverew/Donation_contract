//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract CharitableDonation {

    // Struct to hold charitable donors
    modifier nonZeroValue() { 
        if (!(msg.value > 0)) revert();
     _; }
     uint donateAmount;

    struct Donor {
        string name;
        uint amount;
    }

    // Struct for each charity that can receive donations

    struct Charity {
        address payable charityAddr;
        string name;
        uint donationsAccumulated;
        uint targetAmount;
        // a mapping of an individual donor address to a Donor struct which tracks their donation
        mapping(address=>Donor) donors;
    }

    // The charity
    Charity public charity;

    address public administrator;

    // Constructor

    constructor(address payable charityAddress,  string memory charityName) {
        administrator = msg.sender;
        charity.charityAddr = charityAddress;        
        charity.name = charityName;        
    }

    // set the donation target amount
    function setTargetAmount(uint _targetAmount) public {
        require(msg.sender == administrator, "Only the administrator can set the donation target amount!");
        charity.targetAmount = _targetAmount;
   }

   // If you choose to do this assignment, write the following functions:
   // 1. A function to allow for a donor to make a donation, and track the accumulated donations;
   function donate(uint _donateAmount) public payable nonZeroValue{
        require(msg.value==_donateAmount);
        donateAmount+=_donateAmount;
        if (donateAmount==charity.targetAmount){
            withdraw();
        }
    }
   // 2. A function to check if the target amount has been reached, and then releases the funds
   function withdraw() private{
            payable(charity.charityAddr).transfer(donateAmount);
   //    from the contract to the charity.
    }
   }