// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatorPrizeContract is ERC721URIStorage, Ownable {
    constructor(
        address initialOwner
    ) ERC721("Votoppia Creator Prize", "CPNFT") Ownable(initialOwner) {}

    uint256 public mintedCount = 0;

    function stringToUint(string memory s) private pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }

    function padZero(
        uint256 input,
        uint256 totalLength
    ) private pure returns (string memory) {
        string memory output = Strings.toString(input);
        while (bytes(output).length < totalLength) {
            output = string(abi.encodePacked("0", output));
        }
        return output;
    }

    function mint(
        uint256 tokenPrefix,
        uint256 expiration,
        address addr
    ) public onlyOwner returns (uint256) {
        require(
            expiration > block.timestamp && expiration < 9_999_999_999,
            "Invalid expiration"
        );

        require(
            tokenPrefix > 100_000 && tokenPrefix < 999_999,
            "Invalid prefix"
        );

        mintedCount += 1;
        string memory scarcityString = padZero(mintedCount, 14);

        uint256 tokenId = stringToUint(
            string(
                abi.encodePacked(
                    Strings.toString(tokenPrefix),
                    scarcityString,
                    Strings.toString(expiration)
                )
            )
        );

        _safeMint(addr, tokenId);
        _setTokenURI(
            tokenId,
            string(abi.encodePacked(Strings.toString(tokenId), ".json"))
        );

        return tokenId;
    }

    function totalSupply() public pure returns (uint256) {
        return 999_999_999_999_99;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.votoppia.com/nfts/metadata/";
    }
}
