// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721, Ownable {

 using Strings for uint256;

 uint256 public constant MAX_TOKENS = 10;
 uint256 public constant TOKENS_RESERVED = 1;
 uint256 public price =  0;
 uint256 public constant MAX_MINT_PER_TX = 1;

 bool public isSaleActive;
 uint256 public totalSupply;

 mapping (address => uint256) private mintedPerWallet;

 string public baseUri;
 string public baseExtension = ".json";


    constructor() ERC721("Endall Batan NFT", "EB-NFT") {

        // BASE IPF URI of the NFTS
        baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        for (uint256 i=1; i <= TOKENS_RESERVED; i++) {
            _safeMint(msg.sender, i);
        }
    }

    //PUBLIC FUNCTIONS
    function mint(uint256 _numTokens ) external payable  {
        require(isSaleActive, "The sale is paused");
        require(_numTokens <= MAX_MINT_PER_TX, "You can only mint a maximum of 'MAX_MINT_PER_TX'");
        require(mintedPerWallet[msg.sender] + _numTokens <= 10, "You can only mint 'MAX_MINT_PER_TX' per Wallet");
        uint256 curlTotalSupply = totalSupply;
        require(curlTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds 'MAX_TOKENS'");
        require(_numTokens * price <= msg.value, "Insufficient funds. You need mor ETH!");

        for (uint256 i=1; i <=_numTokens; i++) {
            _safeMint(msg.sender, curlTotalSupply + 1);
        }

        mintedPerWallet[msg.sender] += _numTokens;
        curlTotalSupply += _numTokens;

    }

    //OWNER ONLY FUNCTIONS - callable only by deployer of contract
    
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setBaseURU(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    
}