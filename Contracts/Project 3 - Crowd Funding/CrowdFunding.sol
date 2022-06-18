// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

contract CrowdFunding {
    mapping(address => uint256) public Contributors;
    address public Manager;
    uint256 public minContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raiseAmount;
    uint256 public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool isCompleted;
        uint256 noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public numRequests;

    constructor(uint256 _target, uint256 _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minContribution = 100 wei;
        Manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "deadline has been passed");
        require(msg.value >= 100 wei, "Minimum Contribution is not met");

        if (Contributors[msg.sender] == 0) {
            noOfContributors++;
        }

        Contributors[msg.sender] += msg.value;
        raiseAmount += msg.value;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function refund() public {
        require(
            block.timestamp > deadline && raiseAmount < target,
            "you are not eligble to refund"
        );
        require(Contributors[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(Contributors[msg.sender]);
        Contributors[msg.sender] = 0;
    }

    modifier onlyMnager() {
        require(msg.sender == Manager, " Only manager can call the function");
        _;
    }

    function createRequest(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public onlyMnager {
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.isCompleted = false;
        newRequest.noOfVoters = 0;
    }

    function VoteRequest(uint256 _requestNo) public {
        require(Contributors[msg.sender] > 0, "you are not a contributor");
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.voters[msg.sender] == false,
            " you have already voted"
        );
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint256 _requestNo) public onlyMnager {
        require(raiseAmount >= target);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.isCompleted == false, "Already dirtibuted amount");
        require(
            thisRequest.noOfVoters > noOfContributors / 2,
            "Majority does not support"
        );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.isCompleted = true;
    }
}