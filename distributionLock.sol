pragma solidity 0.5.16;

import './lockClaim.sol';

contract distributionClaim {
 
    lockClaim private _lockClaim;
    
    address private contractOwner;
    
    uint256 private idoStartTime;
    
    uint256 private idoEndingTime;
    
    modifier onlyOwner() {
        require(contractOwner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    function setIdoStartEndTime(uint256 _timestamp) public onlyOwner {
        idoStartTime  = block.timestamp;
        idoEndingTime = block.timestamp + _timestamp * 1 days;
    }
    
    constructor(address _lockClaimAddress) public onlyOwner {
         contractOwner = msg.sender;
        _lockClaim = lockClaim(_lockClaimAddress);
    }
    
    function startDistribution() external {
       
       bool result=  _lockClaim.isAddressClaimableForDistribution(msg.sender,idoStartTime,idoEndingTime);
       if(result){//dağıtımı hesapla ve gönderim yap
           
       }
        
    }
    

    
    
}
