// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Vote {
    struct Voter {
        uint amount; //票数
        bool isVoted; //是否投过票了
        address delegator; //代理人地址
        uint targetId;  //投给谁的id
    }

    //投票看板结构体
     struct Board {
        string name;  //目标名字
        uint256 totalAmount;   //票数
     }

    //  主持人信息
    address public host;

    // 创建投票人集合
    mapping(address => Voter) public voters;

    // 投票人得分集合  姓名+票数
    Board[] public board;
    // 数据初始化
    constructor(string [] memory nameList) {
        host = msg.sender;
        voters[host].amount = 1;

        for(uint256 i = 0;i <= nameList.length; i++) {
            Board memory boardItem = Board(nameList[i],0);
            board.push(boardItem);
        }
    }

    // 返回看板集合
    function getBoardInfo() public view returns (Board[] memory) {
        return board;
    }

    // 给某些地址赋予选票
    function mamdate(address[] calldata addressList) public {
        // 只有主持人可以调用该方法
        require(msg.sender == host,"Only the owner has permissions.");
        for (uint256 i = 0; i < addressList.length;i++ ) {
            // 如果该地址已经投过票,不做处理
            if (!voters[addressList[i]].isVoted) {
                voters[addressList[i]].amount = 1;    //给一票
            }
        }
    }
    // 将投票权委托给别人
     function delegate (address to) public {
        //获取委托人的地址
        Voter storage sender = voters[msg.sender];
        // 如果委托人已经投过票了,就不能再委托别人投票了
        require(!sender.isVoted,unicode"你已经投过票了.");
        // 不能委托给自己
        require(msg.sender !=  to,unicode"不能委托给自己."); 
        // 避免循环委托
        while (voters[to].delegator != address(0)) {
            to = voters[to].delegator;
            require(to==msg.sender,unicode"不能循环授权.");
        }
        // 开始授权
        sender.isVoted = true;
        sender.delegator = to;
        
        // 获取代理人信息,代理人数据的修改
        Voter storage delegator_ = voters[to];
        if (delegator_.isVoted) {
            // 追票
            board[delegator_.targetId].totalAmount += sender.amount;
        } else {
            delegator_.amount += sender.amount;
        }

     }
    // 投票
    function vote(uint256 targetId) public {
        Voter storage sender = voters[msg.sender];
        require(sender.amount != 0, "Has no right to vate.");
        require(!sender.isVoted,"Already noted.");
        sender.isVoted = true;
        sender.targetId = targetId;
        board[targetId].totalAmount += sender.amount;
        emit voteSuccess( unicode'投票成功');
    } 
    // 投票成功事件
    event voteSuccess(string);
}
