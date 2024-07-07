// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract CrowdFunding {

    address public immutable beneficiary;
    uint256 public immutable fundingGoal; //集资目标
    uint256 public fundingAmount; // 集资金额

    mapping(address=>uint256) public funders; //出资人
    mapping(address=>bool) private funderInserted;

    address[] public fundersKey;

    bool public AVAILABLE = true;

    constructor(address beneficiary_, uint256 goal_) { //why need constructor here
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }
    
    function contribute() external payable{
        require(AVAILABLE, "CrowdFunding is closed");

        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;

        if (potentialFundingAmount > fundingGoal) {
            refundAmount = potentialFundingAmount - fundingGoal;
            funders[msg.sender] += (msg.value - refundAmount);
            fundingAmount += (msg.value - refundAmount);
        } else {
            funders[msg.sender] += msg.value;
            fundingAmount += msg.value;
        }

        if (!funderInserted[msg.sender]) {
            funderInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }

        if (refundAmount > 0){
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function close() external returns(bool){
        if(fundingAmount<fundingGoal){
            return false;
        }
        uint256 amount = fundingAmount;
        fundingAmount = 0;
        AVAILABLE = false;
        payable(beneficiary).transfer(amount);
        return true;
    }

    function fundersLenght() public view returns(uint256){
        return fundersKey.length;
    }
}