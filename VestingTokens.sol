// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VestingTokens is ERC20
{

    struct vestingSchedule {
        uint256 cliff;
        uint256 duration;
        uint256 tokensGiven;
        uint256 releasedTokens;
    }
    
    mapping(address=>vestingSchedule) public beneficiaries;

    uint256 totalTokens;
    uint256 usersTokens;
    uint256 partnersTokens;
    uint256 teamsTokens;

    uint256 allocatedUsersTokens;
    uint256 allocatedPartnersTokens;
    uint256 allocatedTeamsTokens;

    address public owner;
    uint256 public startTime;
    bool public vestingStarted=false;

    event VestingStarted(uint256 startTime);
    event BeneficiaryAdded(address indexed beneficiary,uint256 totalTokens,string role);
    event TokensReleased(address indexed beneficiary,uint256 tokens);

    modifier onlyOwner(){
        require(msg.sender==owner,"Caller is not the Owner");
        _;
    }

    constructor(uint256 _totalTokens) ERC20("Vesting","VC"){
        _mint(address(this),_totalTokens);
        owner=msg.sender;
        totalTokens=_totalTokens;
        usersTokens=totalTokens*50 / 100;
        partnersTokens=totalTokens *25 /100;
        teamsTokens=totalTokens *25 /100;
    }

    function startVesting() external onlyOwner{
        require(!vestingStarted,"Vesting is already Started");
        require(balanceOf(address(this)) >= totalTokens,"Insufficient tokens in Contract");
        startTime=block.timestamp;
        vestingStarted=true;
        emit VestingStarted(startTime);
    } 

    function addBeneficiary(address _beneficiary,uint256 _tokensGiven,string memory role)external onlyOwner{
        require(!vestingStarted,"Vesting already Started");
        require(beneficiaries[_beneficiary].tokensGiven==0,"Beneficiary already added");

        if (keccak256(abi.encodePacked(role)) == keccak256("User")) {
            require(allocatedUsersTokens + _tokensGiven <= usersTokens, "User allocation exceeded"); 
            allocatedUsersTokens += _tokensGiven; 
            beneficiaries[_beneficiary] = vestingSchedule({
             cliff: 120, 
             duration: 200, 
             tokensGiven: _tokensGiven,
              releasedTokens: 0 });
            } 
        else if (keccak256(abi.encodePacked(role)) == keccak256("Partner")) { 
            require(allocatedPartnersTokens + _tokensGiven <= partnersTokens, "Partner allocation exceeded"); 
            allocatedPartnersTokens += _tokensGiven;
            beneficiaries[_beneficiary] = vestingSchedule({
             cliff: 30, 
             duration: 100, 
             tokensGiven: _tokensGiven,
              releasedTokens: 0 }); } 
        else if (keccak256(abi.encodePacked(role)) == keccak256("Team")) { 
            require(allocatedTeamsTokens + _tokensGiven <= teamsTokens, "Team allocation exceeded");
            allocatedTeamsTokens += _tokensGiven; 
             beneficiaries[_beneficiary] = vestingSchedule({
             cliff: 60,
             duration: 100 ,
             tokensGiven: _tokensGiven,
              releasedTokens: 0 });} 
        else {
             revert("Invalid role"); }
       

        emit BeneficiaryAdded(_beneficiary, _tokensGiven, role);
    }

    function releaseTokens() payable external{
        vestingSchedule storage schedule=beneficiaries[msg.sender];
        require(schedule.tokensGiven>0,"No tokens to transfer");

        uint256 unreleasedTokens=releasableTokens(msg.sender);
        require(unreleasedTokens>0,"No tokens due to release");
        
        schedule.releasedTokens+=unreleasedTokens;
        _transfer(address(this),msg.sender, unreleasedTokens);
        emit TokensReleased(msg.sender, unreleasedTokens);
        
        

    }
    function releasableTokens(address _beneficiary)public view returns (uint256){
        return vestedAmount(_beneficiary)-beneficiaries[_beneficiary].releasedTokens;
    }

    function vestedAmount(address _beneficiary)public view returns (uint256){
        vestingSchedule storage schedule=beneficiaries[_beneficiary];
        if(block.timestamp<startTime + schedule.cliff){
            return 0;
        }
        else if(block.timestamp>=startTime+schedule.duration){
            return schedule.tokensGiven;
        }
        else{
            return schedule.tokensGiven*(block.timestamp-(startTime+schedule.cliff))/schedule.duration;
        }
        
    }

}
