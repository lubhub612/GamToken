pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract GamBar is ERC20("GamBar", "xGAM"){
    using SafeMath for uint256;
    IERC20 public gam;

    constructor(IERC20 _gam) public {
        gam = _gam;
    }

    
    function enter(uint256 _amount) public {
        uint256 totalGam = gam.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalGam == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalGam);
            _mint(msg.sender, what);
        }
        gam.transferFrom(msg.sender, address(this), _amount);
    }

    
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(gam.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        gam.transfer(msg.sender, what);
    }
}