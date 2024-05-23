// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    struct Voter {
        uint amount; // 票数
        bool isVoted; // 是否投过票了
        address delegator; // 代理人地址
        uint targetId;  // 投给谁的id
    }

    // 投票看板结构体
    struct Board {
        string name;  // 目标名字
        uint256 totalAmount;   // 票数
    }

    // 主持人信息
    address public host;

    // 创建投票人集合
    mapping(address => Voter) public voters;

    // 投票目标集合  姓名+票数
    Board[] public board;

    // 数据初始化
    constructor(string[] memory nameList) {
        host = msg.sender;
        voters[host].amount = 1;

        for(uint256 i = 0; i < nameList.length; i++) {
            Board memory boardItem = Board(nameList[i], 0);
            board.push(boardItem);
        }
    }

    // 返回看板集合
    function getBoardInfo() public view returns (Board[] memory) {
        return board;
    }

    // 给某些地址赋予选票
    function mamdate(address[] calldata addressList) public {
        require(msg.sender == host, "Only the owner has permissions.");
        
        for (uint256 i = 0; i < addressList.length; i++) {
            if (!voters[addressList[i]].isVoted) {
                voters[addressList[i]].isVoted = false;
                voters[addressList[i]].amount = 1;    // 给一票
            }
        }
    }

    // 将投票权委托给别人
    function delegate (address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.isVoted, "You have already voted.");
        require(msg.sender != to, "Cannot delegate to yourself.");

        address currentDelegate = to;
        while (voters[currentDelegate].delegator != address(0)) {
            currentDelegate = voters[currentDelegate].delegator;
            require(currentDelegate != msg.sender, "Cannot delegate in a loop.");
        }

        sender.isVoted = true;
        sender.delegator = to;

        Voter storage delegator_ = voters[to];
        if (delegator_.isVoted) {
            board[delegator_.targetId].totalAmount += sender.amount;
        } else {
            delegator_.amount += sender.amount;
        }
    }

    // 投票
    function vote(uint256 targetId) public {
        Voter storage sender = voters[msg.sender];
        require(sender.amount != 0, "Has no right to vote.");
        require(!sender.isVoted, "Already voted.");
        
        sender.isVoted = true;
        sender.targetId = targetId;
        board[targetId].totalAmount += sender.amount;
        emit voteSuccess("Vote successful");
    } 

    // 投票成功事件
    event voteSuccess(string message);
}
