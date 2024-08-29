
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedAuction {

    enum AuctionType { English, Dutch, SealedBid }
    
    struct Auction {
        address creator;
        AuctionType auctionType;
        uint256 startPrice;
        uint256 reservePrice;
        uint256 biddingIncrement;
        uint256 endTime;
        bool finalized;
        address highestBidder;
        uint256 highestBid;
        mapping(address => uint256) bids;
    }

    uint256 public auctionCount;
    mapping(uint256 => Auction) public auctions;

    // Event to log auction creation
    event AuctionCreated(uint256 indexed auctionId, address indexed creator, AuctionType auctionType, uint256 startPrice, uint256 reservePrice, uint256 endTime);
    
    // Event to log a new bid
    event NewBid(uint256 indexed auctionId, address indexed bidder, uint256 amount);
    
    // Event to log auction finalization
    event AuctionFinalized(uint256 indexed auctionId, address indexed winner, uint256 winningBid);

    modifier onlyAuctionCreator(uint256 _auctionId) {
        require(msg.sender == auctions[_auctionId].creator, "Only auction creator can perform this action");
        _;
    }

    modifier auctionExists(uint256 _auctionId) {
        require(_auctionId < auctionCount, "Auction does not exist");
        _;
    }

    modifier auctionActive(uint256 _auctionId) {
        require(block.timestamp < auctions[_auctionId].endTime, "Auction has ended");
        _;
    }

    modifier auctionEnded(uint256 _auctionId) {
        require(block.timestamp >= auctions[_auctionId].endTime, "Auction is still ongoing");
        _;
    }

    // Function to create a new auction
    function createAuction(
        AuctionType _auctionType,
        uint256 _startPrice,
        uint256 _reservePrice,
        uint256 _biddingIncrement,
        uint256 _duration
    ) public {
        require(_duration > 0, "Auction duration must be greater than zero");

        uint256 auctionId = auctionCount++;
        Auction storage auction = auctions[auctionId];
        auction.creator = msg.sender;
        auction.auctionType = _auctionType;
        auction.startPrice = _startPrice;
        auction.reservePrice = _reservePrice;
        auction.biddingIncrement = _biddingIncrement;
        auction.endTime = block.timestamp + _duration;
        auction.finalized = false;

        emit AuctionCreated(auctionId, msg.sender, _auctionType, _startPrice, _reservePrice, auction.endTime);
    }

    // Function to place a bid in an auction
    function placeBid(uint256 _auctionId) public payable auctionExists(_auctionId) auctionActive(_auctionId) {
        Auction storage auction = auctions[_auctionId];
        require(msg.value > 0, "Bid amount must be greater than zero");
        require(msg.value >= auction.highestBid + auction.biddingIncrement, "Bid amount must be higher than the current highest bid plus the increment");

        auction.bids[msg.sender] += msg.value;

        // Assert to ensure the bid value is correctly updated
        assert(auction.bids[msg.sender] == msg.value); 

        if (msg.value > auction.highestBid) {
            auction.highestBid = msg.value;
            auction.highestBidder = msg.sender;
        }

        emit NewBid(_auctionId, msg.sender, msg.value);
    }

    // Function to finalize the auction and transfer funds
    function finalizeAuction(uint256 _auctionId) public auctionExists(_auctionId) auctionEnded(_auctionId) onlyAuctionCreator(_auctionId) {
        Auction storage auction = auctions[_auctionId];
        require(!auction.finalized, "Auction is already finalized");

        if (auction.highestBid >= auction.reservePrice) {
            payable(auction.creator).transfer(auction.highestBid);
            emit AuctionFinalized(_auctionId, auction.highestBidder, auction.highestBid);
        } else {
            // Return funds to the highest bidder if reserve price is not met
            payable(auction.highestBidder).transfer(auction.highestBid);
        }
        
        auction.finalized = true;

        // Using assert to ensure the auction is marked as finalized
        assert(auction.finalized == true);
    }

    // Function to retrieve a user's bid for a specific auction
    function getUserBid(uint256 _auctionId, address _user) public view returns (uint256) {
        return auctions[_auctionId].bids[_user];
    }

    // Function to cancel an auction if it has no bids
    function cancelAuction(uint256 _auctionId) public auctionExists(_auctionId) onlyAuctionCreator(_auctionId) auctionActive(_auctionId) {
        Auction storage auction = auctions[_auctionId];

        // Ensure the auction has no bids
        if (auction.highestBid > 0) {
            revert("Cannot cancel auction with active bids");
        }

        auction.finalized = true;
    }
}
