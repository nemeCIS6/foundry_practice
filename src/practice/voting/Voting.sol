// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {console} from "forge-std/console.sol";

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    struct ProposalVote{
        uint proposalId;
        bool hasVoted;
        bool vote;
    }
    
    event ProposalCreated (uint proposalId);
    event VoteCast (uint proposalId, address voterAddress);
    Proposal[] public proposals;
    mapping(address=>ProposalVote) voters;
    address[] public voterList;

    constructor(address[] memory addresses) {
        voterList = addresses;
        voterList.push(msg.sender);
    }

    function newProposal(address _target, bytes calldata _data) onlyVoters external{
        Proposal memory _newProposal = Proposal({
            target: _target,
            data: _data,
            yesCount: 0,
            noCount: 0
        });
        proposals.push(_newProposal);
        emit ProposalCreated(proposals.length-1);
    }

    function castVote(uint proposalId, bool vote) onlyVoters external{
        if(voters[msg.sender].hasVoted){
            changeVote(proposalId, vote);
            emit VoteCast(proposalId, msg.sender);
            return;
        }
        if(vote) {
            proposals[proposalId].yesCount++;
        }else{
            proposals[proposalId].noCount++;
        }
        voters[msg.sender]=ProposalVote({
            proposalId: proposalId,
            vote: vote,
            hasVoted: true
        });
        emit VoteCast(proposalId, msg.sender);
        executeProposal(proposalId);
    }

    function changeVote(uint proposalId, bool vote) onlyVoters internal{
        if(voters[msg.sender].vote == vote){
            console.log("same vote");
            return;
        }
        if(vote){
            proposals[voters[msg.sender].proposalId].yesCount++;
            if(proposals[voters[msg.sender].proposalId].noCount > 0)
            {
                proposals[voters[msg.sender].proposalId].noCount--;
            }
            executeProposal(proposalId);
            return;
        }
        if(proposals[voters[msg.sender].proposalId].yesCount > 0)
        {
            proposals[voters[msg.sender].proposalId].yesCount--;
        }
            proposals[voters[msg.sender].proposalId].noCount++;
    }

    function executeProposal(uint proposalId) internal{
        if(proposals[proposalId].yesCount < 10){
            return;
        }
        require(proposals[proposalId].yesCount >= 10, "Votes insufficient for execution");
        (bool success,) = proposals[proposalId].target.call(proposals[proposalId].data);
        require(success, "Proposal execution failed");
    }

    modifier onlyVoters{
        bool allowed = false;
        for(uint i=0; i<voterList.length; i++){
            if(msg.sender == voterList[i]){
                allowed = true;
                break;
            }
        }
        require(allowed, "Not in voter list");
        _;
    }

}
