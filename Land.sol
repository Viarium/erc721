pragma solidity ^0.4.18;
//contract for work with Land specification
contract Land {
    
    //Convert id Land to land's coordinate (external)
    function coordOfNum(uint256 lLand) external view returns (uint128, uint128) {
        return (uint128(lLand>>128), uint128(lLand));
    }
    
    //Convert land's coordinate to land's id (external)
    function numOfCoord(uint128 x, uint128 y) external view returns (uint256) {
        return (uint256(x)<<128) + uint256(y);
    }
    
    //Convert id Land to land's coordinate (internal)
    function numOfCoordI(uint128 x, uint128 y) internal returns (uint256) {
        return (uint256(x)<<128) + uint256(y);
    }
    
    //Convert land's coordinate to land's id (internal)
    function coordOfNumI(uint256 lLand) internal returns (uint128, uint128) {
        return (uint128(lLand>>128), uint128(lLand));
    }
}
