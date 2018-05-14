
//合约编译 : http://remix.ethereum.org/

// import "./erc20.sol"

pragma solidity ^0.4.20;
//接口文档 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
contract ERC20Interface{
//代币名称(可选)
    function name()public view returns (string);
//代币符号(可选)
    function symbol() public view returns (string);
//代币精度(可选)
    function decimals() public view returns (uint8);

//代币总量
    function totalSupply()public view returns (uint256);
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
}
contract Owner{
    //函数修饰
    //文档: http://solidity-cn.readthedocs.io/zh/develop/contracts.html#function-modifiers
    address owner;
    modifier onlyOwner{
        require(msg.sender == owner);
        //_ 表示修饰的函数的本体替换
        _;
    }
    constructor() public{ owner = msg.sender; }
}
interface Burn{
    function burn(uint256)external;
}
contract Token is ERC20Interface,Owner,Burn {
    //合约中的值为永久存储的值 storage
    //函数中的值默认为临时值 memory
    //使用关键字可以指定存储位置 
    //文档: http://solidity-cn.readthedocs.io/zh/develop/types.html?#data-location

    string m_name;
    string m_symbol;
    uint8 m_decimals;
    uint256 m_totalSupply;

    //bool 类型
    bool m_isStop=false;

    //Array类型 数组,length,push 2个函数
    //文档: http://solidity-cn.readthedocs.io/zh/develop/types.html?#array-literals-inline-arrays
    address[] m_admins;

    //struct 结构体
    //文档: http://solidity-cn.readthedocs.io/zh/develop/types.html?#structs
    struct Funder {
        address addr;
        uint amount;
    }

    //回退函数 无名的
    //文档: http://solidity.readthedocs.io/en/v0.4.21/contracts.html#fallback-function
    function() public payable {
        //仅有2300 gas

        //向区块链中写数据
        //创建一个合约
        //调用一个external的函数
        //发送ether
        
        //这四个操作都将超过gas而不能运行.
        //仅仅只能做一些日志操作
        //eth的DAO事件与这个函数相关
        //DAO事件模拟重现: https://blog.csdn.net/u011721501/article/details/79450122
    }

    //onlyOwner modifier的作用
    function close()public onlyOwner{
        selfdestruct(owner);
    }

    //实现接口
    function burn(uint256 m_v)external{
        require(m_balances[msg.sender]>=m_v);
        m_balances[msg.sender] -= m_v;
    }

    //payable 修饰,有人转入以太的时候 payable 函数执行 ,0.4.x版本后,发送以太到没有payable的函数时,将会被拒绝
    //stackoverflow: https://ethereum.stackexchange.com/questions/20874/payable-function-in-solidity
    uint256 m_money=0;
    // 以太1:1 兑换 token
    function etherToToken() public payable
    returns(uint256){

        //msg.value 全局变量 这个消息发送的以太数量 (单位为: wei)
        //msg 在每个external(外部)函数都可能是不同的.
        //文档: http://solidity-cn.readthedocs.io/zh/develop/units-and-global-variables.html
        // block(区块对象) msg(消息对象) now(当前块的时间戳) tx(当前交易的对象)
        require(msg.value>0);
        require(msg.value+m_money>m_money);
        m_money += msg.value;
        m_balances[msg.sender] += msg.value;
        return msg.value;
    }

    //mapping,映射关系,不可迭代.具体的实现是使用keccak256的 hash table
    //文档地址: http://solidity-cn.readthedocs.io/zh/develop/types.html?highlight=public#mappings
    mapping(address => uint256) m_balances;
    //address 20byte大小,一个以太网地址
    //文档地址: http://solidity-cn.readthedocs.io/zh/develop/types.html?highlight=public#address
    mapping(address => mapping (address => uint256)) m_allowed;
    //写在 构造参数或者构造函数写死或者声明时就写死
    // constructor 保证在合约创建时运行一次
    constructor()public{
        //String Literals 支持转义以及Unicode,默认utf-8,例如: "\uNNNN"
        //文档地址: http://solidity-cn.readthedocs.io/zh/develop/types.html?highlight=public#string-literals
        m_name = "SMMTOKEN";
        m_symbol = "SMM";
        m_decimals = 8;
        m_totalSupply = 10**uint256(m_decimals);
        m_balances[msg.sender] = m_totalSupply;
    }
    //view 修饰函数 不允许修改
    //pure 修饰函数 不允许修改或访问
    //payable 修饰函数 接收到以太时调用时
    //constant 修饰变量 禁止复制,初始化除外
    //constant 修饰函数 跟view一样
    //anonymous 修饰事件 不会存储
    //indexed 修饰事件 存储参数
    //文档: http://solidity-cn.readthedocs.io/zh/develop/miscellaneous.html?highlight=view#modifiers

    function name()public view
    returns(string){
        return m_name;
    }
    function symbol()public view
    returns(string){
        return m_symbol;
    }
    function decimals()public view
    returns(uint8){
        return m_decimals;
    }
    function totalSupply()public view
    returns(uint256){
        //会溢出么?
        return m_totalSupply+m_money;
    }
    function balanceOf(address m_own)public view
    returns(uint256){
        return m_balances[m_own];
    }

    //internal 表明内部的,只有合约和继承这个合约的能访问,类似c++ protected
    //external 标识着只能外部访问
    //public 都可以访问
    //private 只有这个合约能访问

    //类型默认都是内部的,函数默认都是外部的
    //文档: http://solidity-cn.readthedocs.io/zh/develop/contracts.html#visibility-and-getters
    //文档: http://solidity-cn.readthedocs.io/zh/develop/types.html#function-types
    //stackoverflow: https://ethereum.stackexchange.com/questions/32353/what-is-the-difference-between-an-internal-external-and-public-private-function

    function m_transfer(address m_from,address m_to,uint256 m_v)internal {
        
        //文章来源: https://media.consensys.net/when-to-use-revert-assert-and-require-in-solidity-61fb2c0e5a57
        //require用于条件检查
        //检查余额
        require(m_balances[m_from]>=m_v);
        //防止溢出
        require(m_balances[m_to]+m_v>m_balances[m_to]);
        require(m_balances[m_from]-m_v<m_balances[m_from]);
        
        //var 类型推导 (不推荐使用)
        //文档 http://solidity-cn.readthedocs.io/zh/develop/types.html?#type-deduction
        var check = m_balances[m_to]+m_balances[m_from];
        m_balances[m_to] += m_v;
        m_balances[m_from] -= m_v;

        //event 发射这个事件,以太坊的虚拟机会捕捉到
        //文档: http://solidity-cn.readthedocs.io/zh/develop/contracts.html#events
        emit Transfer(m_from,m_to,m_v);
        // assert 检查不可能发生的事,防止发生真正的坏事
        assert(m_balances[m_to]+m_balances[m_from]==check);
        // revert 直接抛出错误
    }
    function transfer(address m_to,uint256 m_v)public 
    returns(bool){
        m_transfer(msg.sender,m_to,m_v);
        return true;
    }
    function transferFrom(address m_from,address m_to,uint256 m_v)public
    returns(bool){
        m_transfer(m_from,m_to,m_v);
        return true;
    }

    function approve(address m_send,uint256 m_v)public
    returns(bool){
        m_allowed[msg.sender][m_send] = m_v;
        return true;
    }

    function allowance(address m_own,address m_send)public view
    returns(uint256){
        return m_allowed[m_own][m_send];
    }

}
