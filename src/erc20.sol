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