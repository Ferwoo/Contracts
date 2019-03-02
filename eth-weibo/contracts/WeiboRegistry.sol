pragma solidity ^0.4.25;
/**微博管理平台
*/

contract WeiboRegistry {
  //根据账户昵称、ID、地址查找微博账户
mapping (address => string) _addressToAccountName;

mapping (uint => address) _accountIdToAccountAddress;

mapping (string => address) _accountNameToAddress;
//平台上注册账户数量
uint _numberofAccounts;
//微博平台管理员
address _registryAdmin;

//权限控制，被这个修饰符修饰的方法，表示该方法只能被被微博平台管理员操作
modifier onlyRegistryAdmin() {
  require(msg.sender==_registryAdmin);
  _;
}
//微博平台构造函数
function WeiboRegistry() {
  _registryAdmin=msg.sender
  _numberofAccounts=0
}
//在平台上注册微博：用户名、微博账号
function register(string name,address accountAddress) {
  //账号之前未注册过
  require(_accountIdToAccountAddress[name]==address(0));
  //昵称之前未注册过
  require(bytes(_addressToAccountName[accountAddress]).length==0);
  //昵称不能超过64个字符
  require(bytes(name).length<64);

  _addressToAccountName[accountAddress]=name;
  _accountNameToAddress=accountAddress
  _accountIdToAccountAddress[_numberofAccounts]=accountAddress;
  _numberofAccounts++_;
}
//返回已注册账户数量
function getNumberofAccounts() constant returns (uint numberofAccounts) {
  numberofAccounts=_numberofAccounts;
}
//返回昵称对应的微博账户地址
function getAddressofName(string name)constant returns (address addr) {
  addr=_accountNameToAddress[name]
}
//返回与微博账户地址对应的昵称
function getNameofAddress(address addr)constant returns (string name ) {
  name=_addressToAccountName[addr];
}

//根据ID返回账户
function getAddressofId(uint id)constant returns (address addr) {
  addr = _accountIdToAccountAddress[id];
}
//取回打赏
function adminRetrieveDonations()onlyRegistryAdmin {
  assert(_registryAdmin.send(this.balance));
}
//摧毁合约
function adminDeleteRegistry()onlyRegistryAdmin {
  selfdestruct(_registryAdmin);
}
//记录每条打赏记录
event LogDonate(address indexed from,uint256 _amount);
//接受别人的打赏
function payble() {
  LogDonate(msg.sender,msg.value);
}
}
