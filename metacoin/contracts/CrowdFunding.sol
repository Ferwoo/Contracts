pragma solidity ^0.4.19;

contract CrowdFunding {


  /* (0) 0x627306090abab3a6e1400e9345bc60c78a8bef57
(1) 0xf17f52151ebef6c7334fad080c5704d77216b732
(2) 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef
(3) 0x821aea9a577a9b44299b9c15c88cf3087f3b5544
(4) 0x0d1d4e623d10f9fba5db95830f7d3839406c6af2
(5) 0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e
(6) 0x2191ef87e392377ec08e7c08eb105ef5448eced5
(7) 0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5
(8) 0x6330a553fc93768f612722bb8c2ec78ac90b3bbc
(9) 0x5aeda56215b167893e80b4fe645ba6d5bab767de */


    // 定义一个`Funder`结构体类型，用于表示出资人，其中有出资人的钱包地址和他一共出资的总额度。
    struct Funder {
        address addr; // 出资人地址
        uint amount;  // 出资总额
    }


   // 定义一个表示存储运动员相关信息的结构体
    struct Campaign {
        address beneficiary; // 受益人钱包地址
        uint fundingGoal; // 需要赞助的总额度
        uint numFunders; // 有多少人赞助
        uint amount; // 已赞助的总金额
        mapping (uint => Funder) funders; // 按照索引存储出资人信息
    }

    uint numCampaigns; // 统计运动员(被赞助人)数量
    mapping (uint => Campaign) campaigns; // 以键值对的形式存储被赞助人的信息


    // 新增一个`Campaign`对象，需要传入受益人的地址和需要筹资的总额
    function newCampaign(address beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // 计数+1
        // 创建一个`Campaign`对象，并存储到`campaigns`里面
        campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
    }

    // 通过campaignID给某个Campaign对象赞助
    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];// 通过campaignID获取campaignID对应的Campaign对象
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value}); // 存储投资者信息
        c.amount += msg.value / 1 ether; // 计算收到的总款
        c.beneficiary.transfer(msg.value);//
    }

    function getCampaignAmount(uint campaignID) public view returns (uint,uint) {
        Campaign storage c = campaigns[campaignID];
        return (c.amount,c.fundingGoal);

    }


    // 检查某个campaignID编号的受益人集资是否达标，不达标返回false，否则返回true
    function checkGoalReached(uint campaignID) public view returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        return true;
    }
}
