pragma solidity ^0.4.25;

/**微博账户
*/

contract WeiboAccount {
  struct Weibo {
    uint timestamp;
    string weiboString;
  }

  //这个微博账户的所有微博，微博ID映射微博内容
  mapping (uint => Weibo) _weibos;

  //账户发的微博数量
  uint _numberofWeibos;

  //微博账户的所有者
  address _adminAddress;

  //权限控制，被这个修饰符修饰的方法，表示改方法只能被微博所有者操作
  modifier onlyAdmin() {
    require(msg.sender==_adminAddress);
    _;//?
  }
//微博合约的构造方法
function WeiboAccount() {
  _numberofWeibos=0;
  _adminAddress=msg.sender;
}
//发新微博
function weibo(string weiboString) onlyAdmin() {
  //微博长度小于160
  require(bytes(weiboString).lenth<=160);
  _weibos[_numberofWeibos].timestamp=now;
  _weibos[_numberofWeibos].weiboString=weiboString;
  _numberofWeibos++;
}

//根据ID查找微博
function getWeibo(uint weiboId) constant returns (string weiboString,uint timestamp) {
  weiboString=_weibos[weiboId].weiboString;
  timestamp=_weibos[weiboId].timestamp;
}

//返回最新一条微博
function getLatestWeibo()constant returns (string weiboString,uint timestamp,uint numberofWibo) {
  //该函数返回三个变量
  weiboString=_weibos[_numberofWeibos-1].weiboString;
  timestamp=_weibos[_numberofWeibos-1].timestamp;
  numberofWeibos=_numberofWeibos;
}
//返回微博账户所有者
function getOwnerAddress()constant returns (address adminAdress) {
  return _adminAddress;
}
//返回微博总数
function getNumberofWeibos()constant returns (uint numberofWeibos) {
  return _numberofWeibos;
}
//取回打赏
function adminRetrieveDonations(address receiver) onlyAdmin() {
  assert(receiver.send(this.balance));
}
//摧毁合约
function adminDeleteAccount()onlyAdmin {
  selfdestruct(_adminAddress);
}
//记录每条打记赏录
event LogDonate(address indexed from ,uint256 _amount);

//接受别人的打赏

function () payable {
  LogDonate(msg.sender, msg.value)
}

}
