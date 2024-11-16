// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
// import "../src/OnChainCreditMarket.sol";
// import "../src/CollateralHook.sol";
// import "../mocks/MockERC20.sol";

// contract OnChainCreditMarketV4Test is Test {
//     OnChainCreditMarketV4 creditMarket;
//     CollateralHook collateralHook;
//     MockERC20 collateralToken;
//     MockERC20 borrowToken;

//     address user;

//     function setUp() public {
//         // Deploy mock tokens
//         collateralToken = new MockERC20("Collateral Token", "COLL", 18);
//         borrowToken = new MockERC20("Borrow Token", "BORR", 18);

//         // Deploy CollateralHook
//         collateralHook = new CollateralHook();

//         // Deploy Credit Market
//         creditMarket = new OnChainCreditMarketV4(address(borrowToken), address(collateralHook));

//         // Assign a test user
//         user = address(1);
//         vm.startPrank(user);

//         // Mint tokens for the user
//         collateralToken.mint(user, 1000 ether);
//         borrowToken.mint(address(creditMarket), 1000 ether);

//         // Approve the credit market to transfer collateral tokens
//         collateralToken.approve(address(creditMarket), 1000 ether);

//         vm.stopPrank();
//     }

//     function testDepositCollateral() public {
//         // Test user deposits 500 collateral tokens
//         vm.startPrank(user);
//         creditMarket.depositCollateral(500 ether, address(collateralHook));
//         vm.stopPrank();

//         // Assert collateral balance
//         (uint256 collateral, uint256 debt) = creditMarket.positions(user);
//         assertEq(collateral, 500 ether);
//         assertEq(debt, 0);
//     }

//     function testBorrow() public {
//         // Deposit collateral first
//         vm.startPrank(user);
//         creditMarket.depositCollateral(500 ether, address(collateralHook));
//         creditMarket.borrow(200 ether);
//         vm.stopPrank();

//         // Assert borrower's debt and token balance
//         (uint256 collateral, uint256 debt) = creditMarket.positions(user);
//         assertEq(collateral, 500 ether);
//         assertEq(debt, 200 ether);
//         assertEq(borrowToken.balanceOf(user), 200 ether);
//     }

//     function testRepay() public {
//         // Deposit and borrow first
//         vm.startPrank(user);
//         creditMarket.depositCollateral(500 ether, address(collateralHook));
//         creditMarket.borrow(200 ether);

//         // Repay the debt
//         borrowToken.approve(address(creditMarket), 100 ether);
//         creditMarket.repay(100 ether);
//         vm.stopPrank();

//         // Assert remaining debt
//         (uint256 collateral, uint256 debt) = creditMarket.positions(user);
//         assertEq(collateral, 500 ether);
//         assertEq(debt, 100 ether);
//     }

//     function testExceedBorrowLimitReverts() public {
//         // Deposit collateral
//         vm.startPrank(user);
//         creditMarket.depositCollateral(500 ether, address(collateralHook));
//         vm.expectRevert("Exceeds borrow limit");
//         creditMarket.borrow(300 ether); // Borrow limit is 250 (50% of 500)
//         vm.stopPrank();
//     }

//     function testHookBeforeSwapFee() public {
//         // Simulate calling beforeSwap
//         vm.startPrank(address(collateralHook)); // Mimic Uniswap calling the hook
//         uint256 fee = collateralHook.beforeSwap(user, address(this), 100 ether, 50 ether);
//         vm.stopPrank();

//         // Assert custom fee is calculated correctly
//         assertEq(fee, (100 ether + 50 ether) / 100); // 1% fee
//     }
// }
