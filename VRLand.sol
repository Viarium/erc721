pragma solidity 0.4.24;

import "../openzeppelin-solidity-master/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin-solidity-master/contracts/token/ERC721/ERC721Token.sol";


contract VRLand is ERC721, ERC721Token {
    struct Coord {
        uint256 bottom;
        uint256 right;
        uint256 top;
        uint256 left;
    };

    address superUser_;
    address objectsAddress_;
    uint32 priceAddLevel_;
    uint16 numOfWorld_;
    
    //Count of lands level
    mapping(uint256=>uint8) levelOfLand_;
    //Type of land (Land|Road|Square)
    mapping(uint256=>uint8) typeOfLand_;
    //ground zero altitude relative to world zero
    mapping(uint256=>uint8) zeroLevelOfLand_;
    //basic world coordinate
    Coord[] worldCoord_;
    //basic world surface
    uint256[] worldSurface_;

    function initialize(bytes) external {
        name_ = "Viarium Land";
        symbol_ = "VRL";
        description_ = "Contract that stores the Viarium land informations";
        superUser_ = msg.sender();
    }

//////////////////////////////////////////////////////////////////////
//////////////   READ METHOD (External)  /////////////////////////////
//////////////   Land       //////////////////////////////////////////
    function typeOfLand (uint256 lLand) external view returns (uint4) {
        return typeOfLand_[lLand];
    }

    function coordOfNum(uint256 lLand) external view returns (uint128, uint128) {
        return (uint128(lLand>>128), uint128(lLand));
    }
    
    function numOfCoordinate(uint128 x, uint128 y) external view returns (uint256) {
        return (uint256(x)<<128) + uint256(y);
    }

    function priceAddLevel () external view returns(uint32) {
        return priceAddLevel_;
    }

    function levelOfLand(uint256 lLand) external view returns (uint8) {
        return levelOfLand_[lLand];
    }

    function zeroLevelOfLand(uint256 lLand) external view returns (uint8) {
        return zeroLevelOfLand_[lLand];
    }

    function objectsAddress () external view returns(address) {
        return objectsAddress_;
    }

//////////////       World        /////////////////////////////////
    function worldCoord(uint8 lNum) external view returns (Coord) {
        require(lNum < worldCoord_.lenth);
        return worldCoord_[lLand];
    } 

    function worldSurface(uint8 lNum) external view returns (uint8) {
        require(lNum < worldSurface_.lenth);
        return worldSurface_[lWorld];
    }
    
    function calculatePriceNewWorld(Coord lNewCoordinate, uint256 lPersonalCol) external view returns(uint256) {
        return calculatePriceNewWorldI(lNewCoordinate, lPersonalCol);
    }
    
    function createNewWorld(Coord lCoordinate, uint256 lSurface) {
        while (i < worldCoord_.lenth) {
            require(intersectionRegion(lCoordinate, i));
        }
        createNewWorld(lCoordinate, lSurface);
    }

/////////////////////////////////////////////////////////////////////
//////////////   WRITE METHOD External  /////////////////////////////
////////////////////    Land    ////////////////////////////////////
    function setZeroLevelOfLand(uint256 lLand, uint8 lLevel) external {
        setZeroLevelOfLandI(lLand, lLevel);
    }
    
    function addLevelOfLand(uint256 lLand) external payable {
        require(msg.value > priceAddLevel_);
        setAddLevelOfLand(lLand);
    }

//////////////       World        /////////////////////////////////
////////////////////////////////////////////////////////////
//////////////   SET  METHOD   /////////////////////////////
    function setObjAdress(address lObjectsAddress) public {
        require(msg.sender == superUser_);
        superUser_ = lObjectsAddress;
    }

    function setPriceAddLevel(address lPriceAddLevel) public {
        require(msg.sender == superUser_);
        priceAddLevel_ = lPriceAddLevel;
    }

    function calculatePriceNewWorldI(Coord lNewCoordinate, uint256 lPersonalCol) internal view returns(uint256) {
        uint256 newCol = (lNewCoordinate.top-lNewCoordinate.bottom)*(lNewCoordinate.right-lNewCoordinate.left);
        return ((0.76*newCol*(newCol/1000.0)**1.5 + allTokens.lenth)/10000.0)*
        (1.0 + lPersonalCol / newCol)**4.0 * newCol * 501.0;
    }

//////////////   WRITE METHOD Private  /////////////////////////////
    function setZeroLevelOfLandI(uint256 lLand, uint8 lLevel) private {
        require(msg.sender == ownerOf(lLand));
        zeroLevelOfLand_[lLand] = lLevel;
    }
    
    function addLevelOfLandI(uint256 lLand) private {
        levelOfLand_[lLand]++;
    }

    function createNewWorldI(Coord lCoordinate, uint256 lSurface) private {
        uint8 i=0;
        worldCoord_.push(lCoordinate);
        worldSurface_.push(lSurface);
        uint256 lCoordLand;
        lCoordLandx = landCoord(lCoordinate.bottom, lCoordinate.left);
        uint8 x = lCoordinate.top - lCoordinate.bottom;
        uint8 y = lCoordinate.left - lCoordinate.right;
        while (i < x) {
            lCoordLandx = landUp() + lCoordLandx;
            lCoordLandy = lCoordLandx;
            while (i < y) {
                lCoordLandy = lCoordLandy + landLeft();
                _mint(lCoordLand, msg.sender);
            }
        }
    }

    function intersectionRegion(Coord lCoordinate, uint8 i) private {
        return(lCoordinate.left > worldCoord_[i].right || 
        lCoordinate.right < worldCoord_[i].left || 
        lCoordinate.top < worldCoord_[i].bottom || 
        lCoordinate.bottom > worldCoord_[i].top);
    }
}
