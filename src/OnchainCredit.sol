pragma solidity ^0.8.0;

import "./CollateralHook.sol";

contract OnChainCreditMarket {
    struct Position {
        uint256 collateral; // LP tokens
        uint256 debt;
    }

    mapping(address => Position) public positions;
    IERC20 public borrowToken;
    CollateralHook public collateralHook;

    uint256 public constant BORROW_RATIO = 50; // 50% of collateral value

    constructor(address _borrowToken, address _collateralHook) {
        borrowToken = IERC20(_borrowToken);
        collateralHook = CollateralHook(_collateralHook);
    }

    function depositCollateral(uint256 amount, address pool) external {
        require(collateralHook.approvedPools(pool), "Pool not approved");
        // Transfer LP tokens to contract
        positions[msg.sender].collateral += amount;
    }

    function borrow(uint256 amount) external {
        Position storage pos = positions[msg.sender];
        uint256 maxBorrow = (pos.collateral * BORROW_RATIO) / 100;
        require(pos.debt + amount <= maxBorrow, "Exceeds borrow limit");

        pos.debt += amount;
        borrowToken.transfer(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        Position storage pos = positions[msg.sender];
        require(pos.debt >= amount, "Repaying more than debt");

        pos.debt -= amount;
        borrowToken.transferFrom(msg.sender, address(this), amount);
    }
}