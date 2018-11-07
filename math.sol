pragma solidity ^0.4.18;

contract math{
    //Calculation of the root of a number in the range from 1000 to 10000
    //The iterative method
    function sqrt1000_10000(uint256 u) public view returns (uint256) {
        uint256 n = u/60;
        n=(n+u/n)/2;
        n=(n+u/n)/2;
        n=(n+u/n)/2;
        return n;
    }
    
}
