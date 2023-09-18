//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; 
 import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ISWap {
    function transfer(address to, uint256 value) external returns (bool success);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract Web3Token is ERC20{
    address web3addr;
    uint public exchangediv = 60;
    
     constructor() ERC20("W3BTOKEN", "W3B"){
        web3addr = msg.sender; 
        _mint(address(this),1_000e18);
    }
    modifier onlyOwner() {
       require(msg.sender == web3addr, "Only Owner");
       _; 
    }
    function mint(address to, uint amount ) external onlyOwner {
        _mint(to, amount);
    }

   
    function buyW3B() external payable {
     uint webvalue = (msg.value / exchangediv);
        _transfer(address(this), msg.sender, webvalue);
    }
}

contract LinkToken is ERC20{
    address linker;
    uint public exchangediv = 15;
     constructor() ERC20("LINK", "LNK"){
        _mint(address(this),1_000e18);
    }

    function buyLink() external payable {
        uint linkvalue = msg.value / exchangediv;
         _transfer(address(this), msg.sender, linkvalue);
    }
    function mint(address to, uint amount ) external {
        _mint(to, amount);
    }
}

contract Swap {
    address payable web3addr;
    address payable linkaddr;
    address owner;
    
    constructor(address payable _linkaddr, address payable _web3addr){
        linkaddr = _linkaddr;
        web3addr = _web3addr;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Only Owner");
        _;
    }
    receive() external payable {}
   
    function exlink4W3B(uint _linktokenAmount) external payable onlyOwner{
         ISWap(linkaddr).transferFrom(msg.sender, address(this), _linktokenAmount);
        uint getW3B = _linktokenAmount / 4;
       // w3btoken.transferFrom(address(this), msg.sender, getW3B);
         ISWap(web3addr).transfer(msg.sender, getW3B);
    }
    function exW3B4link(uint _w3btokenAmount) external payable onlyOwner{
         ISWap(web3addr).transferFrom(msg.sender, address(this), _w3btokenAmount);
        uint getlinktoken = _w3btokenAmount * 4;
       // w3btoken.transferFrom(address(this), msg.sender, getW3B);
         ISWap(linkaddr).transfer(msg.sender, getlinktoken);
    }
}