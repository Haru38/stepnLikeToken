// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Token is  ERC721Enumerable{

    string constant private TOKEN_NAME = "StepnLikeToken";
    string constant private TOKEN_SYMBOL = "SLT";
    address constant private OWNER_ADDRESS = 0x6219573869b345b688980A91fC398B7b04c48c6B;

    string private _base_url;

    constructor() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) Ownable(){
        _transferOwnerShip(OWNER_ADDRESS);
        _base_url = "ipfs://QmPQbUB4ED7gjZmPrFeFdxksCCWPCsUbmayLUV5Y539THc/";
    }


    function readBaseUrl() external view returns(string memory){return _base_url;}

    function setBaseUrl( string calldata url ) external onlyInventoryOrManagers { _base_url = url; }

    function exportToken(uint256 tokenId,address user) external onlyOwner{
        if ( _exists(tokenId)){
            safeTransferFrom(owner(),user,tokenId);
        }else{
            mintToken(tokenId,user);
        }
    }

    function importToken(uint256 tokenId) external {
        require( ownerOf(tokenId) == msg.sender,"is not a token owner");
        safeTransferFrom(msg.sender,inventory(),tokenId);
    }

    function mintToken(uint256 tokenId,address user) public onlyOwner{
        require(tokenId > 0,"invalid token id");
        _safeMint(user,tokenId);
    }

    function batchMintTokens(uint256[] calldata tokenIds,address user) external onlyOwner{
        uint256 idLength = tokenIds.length;
        for (uint256 i = 0;i < idLength;i++){
            _safeMint(user,tokenIds[i]);
        }
    }


    function tokenURI( uint256 tokenId ) public view override returns (string memory) {
        require( _exists( tokenId ), "nonexistent token" );
        return( string( abi.encodePacked( _base_url, Strings.toString( tokenId ) ) ) );
    }

    function getTokenIdsOf( address owner, uint256 pageSize, uint256 pageOfs ) external view  returns (uint256[] memory) {
        uint max = balanceOf( owner );
        uint ofs = pageSize * pageOfs;
        uint num = 0;
        if( ofs < max ){
            num = max - ofs;
            if( num > pageSize ){
                num = pageSize;
            }
        }

        uint256[] memory ids = new uint256[](num);
        for( uint i=0; i<num; i++ ){
            ids[i] = tokenOfOwnerByIndex( owner, ofs+i );
        }

        return( ids );
    }

    function burnToknesFromOwner( uint256[] calldata tokenIds) external onlyOwner {

        for( uint256 i=0; i<tokenIds.length; i++ ){
            require( _exists( tokenIds[i] ), "nonexistent token" );
            require( ownerOf( tokenIds[i] ) == owner(), "token not belong of owner" );
            _burn( tokenIds[i] );
        }
    }
}