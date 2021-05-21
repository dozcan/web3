pragma solidity 0.5.16;

import './lockClaim.sol';
import './SafeMath.sol';

contract distributionClaim {
 
    lockClaim private _lockClaim;
    
    using SafeMath for uint256;
    
    address private contractOwner;
    
    uint256 private idoStartTime;
    
    uint256 private idoEndingTime;
    
    modifier onlyOwner() {
        require(contractOwner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

       //dağıtım işlemeri

    function setIdoStartEndTime(uint256 _timestamp) external onlyOwner {
        idoStartTime  = block.timestamp;
        idoEndingTime = block.timestamp + _timestamp * 1 days;
    }
    
    //kazanılan tüm bnb bakiyeleri bu metod ile bu sozleşmeye gönderilecektir.
    function transferToContractAll() public payable onlyOwner{
        
    }
    
    function getRatioClaimAmount (uint256 a, uint256 b, uint256 amount) internal pure returns(uint256){
         uint256 result = amount.mul(a);
         return result.div(b);
    }
    
    function canRigtForDistribution() external view returns(uint256){
       return idoStartTime;
    }
    
    //verilen tarihler arası hakeden kişinin adresi hangi tier içerisinde ise 
    // bulunur ve kişinin adresine gönderim yapılır
    function startDistribution() external {
       
        uint256 distributionForTier;
        address contractAddress = address(this);
       
        (bool result,uint256 tierIndex) =  _lockClaim.isAddressClaimableForDistribution(msg.sender,idoStartTime,idoEndingTime);
        uint256 nestSize = _lockClaim.getNestSize();
        
        require(result,"need right for claim");//dağıtımı hesapla ve gönderim yap
       
        uint256 totalBalance = contractAddress.balance.div(nestSize);
        
        uint256 newTotalBalance = totalBalance.div(375);
        
        if(tierIndex == 1){
           distributionForTier = getRatioClaimAmount(15,100,newTotalBalance);
        }
        
        else if(tierIndex == 2){
             distributionForTier = getRatioClaimAmount(35,100,newTotalBalance);
        }
        
        else if(tierIndex == 3){
            distributionForTier = getRatioClaimAmount(50,100,newTotalBalance);
        }
        
        
        (bool success, ) =  msg.sender.call.value(distributionForTier)("");
        
        require(success, "Transfer failed for startDistribution ");
       
        
    }
    

    
    
}
