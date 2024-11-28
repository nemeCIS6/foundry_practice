// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract CrossContract {
    /**
     * The function below is to call the price function of PriceOracle1 and PriceOracle2 contracts below and return the lower of the two prices
     */

    function getLowerPrice(
        address _priceOracle1,
        address _priceOracle2
    ) external view returns (uint256) {
        // your code here
        PriceOracle1 p1 = PriceOracle1(_priceOracle1);
        uint pOracle1Price = p1.price();
        PriceOracle2 p2 = PriceOracle2(_priceOracle2);
        uint pOracle2Price = p2.price();
        if(pOracle1Price < pOracle2Price){
            return pOracle1Price;
        }
        return pOracle2Price;
    }
}

contract PriceOracle1 {
    uint256 private _price;

    function setPrice(uint256 newPrice) public {
        _price = newPrice;
    }

    function price() external view returns (uint256) {
        return _price;
    }
}

contract PriceOracle2 {
    uint256 private _price;

    function setPrice(uint256 newPrice) public {
        _price = newPrice;
    }

    function price() external view returns (uint256) {
        return _price;
    }
}