一个去中心化的投票系统

前端内容：

Webpack+_HTML+Vue+CSS+Vuerouter+vantUI:

三个页面：

分发票权，账户信息，投票看板

- **Voter 结构体**:
  - `amount`: 投票人拥有的票数
  - `isVoted`: 是否已经投过票
  - `delegator`: 投票人的代理人地址
  - `targetId`: 投票人投给的目标 ID
- **Board 结构体**:
  - `name`: 投票目标的名称
  - `totalAmount`: 该目标获得的总票数
- **合约属性**:
  - `host`: 合约部署者,即主持人
  - `voters`: 投票人的地址到 Voter 结构体的映射
  - `board`: 投票目标的数组
- **构造函数**:
  - 初始化主持人的投票权为 1 票
  - 根据传入的目标名称列表,初始化投票看板
- **getBoardInfo()**: 返回投票看板的信息
- **mandate(address[] calldata addressList)**: 只有主持人可以调用该方法,给指定地址分配 1 票的投票权,前提是该地址还没有投过票
- **delegate(address to)**: 投票人将自己的投票权委托给其他人,委托后不能再自己投票。委托过程中会检查是否存在循环委托的情况。
- vote: 投票人投票给指定的目标 ID,前提是该投票人拥有投票权且还没有投过票。投票成功后,目标的总票数会增加。
- **voteSuccess 事件**: 在投票成功时触发该事件
