[ERC20接口](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)
[接口样例](https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20Interface.sol)

```sol
//代币名称(可选)
    function name() view returns (string name)
//代币符号(可选)
    function symbol() view returns (string symbol)
//代币精度(可选)
    function decimals() view returns (uint8 decimals)

//代币总量
    function totalSupply() view returns (uint256 totalSupply)
//某个地址持有量
    function balanceOf(address _owner) public view returns (uint256 balance);
//交易给某个地址多少代币
    function transfer(address _to, uint256 _value) public returns (bool success);
//从某个地址交易给另一个地址多少代币
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
//允许一个地址转移你的代币量
    function approve(address _spender, uint256 _value) public returns (bool success);
//捐赠者可以合法的撤出代币量
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

//以及2个事件

//交易的时候必须发射这个时间
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
//转移代币的时候必须发射这个事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
```