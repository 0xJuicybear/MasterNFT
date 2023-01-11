// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <= 0.8.17;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library Strings {

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }
}


interface iMMN{
    function transferOwnership(address newOwner) external;
	function renounceOwnership() external;
	function balanceOf(address owner) external view returns (uint256 balance);
	function MMNCreateERC721(
        string memory name, 
        string memory symbol, 
        uint256 maxNftSupply, 
        uint256 saleStart, 
        uint256 saleEnd, 
        uint256 _MaxPurchase,
        address _sNFTOwner
	)external returns (address);
}

contract MyMasterNFTMain {
    using Address for address;
	
    address public MMNOwner;
    address public MMNExecutor;
    address public MMNPROXY;
    uint256 public MMNSupply;
	uint256 public ReferrerID;
    uint256 public MMNPrice = 1e17; //2 ether
    uint256 public MMNPFPRate = 20;
    uint256 public ReferrerRate = 10;
    uint256 public ReturnRate = 10;
	uint256 public MMNPFPindex;
	uint256 public Partnerindex;
	string public BlindboxImageLink = "https://masternft.io/blindboximg/";
    bool public MMNIsActive = true;
	
    constructor() public{
        MMNOwner = msg.sender;
		MMNExecutor = msg.sender;
    }
	
    struct MMNERC721data {
        address NFTAddr;
        address NFTOwner;
        uint CreatTime;
        uint MaxNftSupply;
    }
	
    mapping(uint256 => MMNERC721data) public MMNData;
	
    mapping(address => uint256) public MMNNFTAmonts;
	
    mapping(address => mapping (uint256 => uint256)) public MMNSortID;

    mapping(address => mapping (uint256 => address)) public MMNNFTAddr;

    mapping(address => uint256) public MMNPass;

    mapping(address => uint256) public ReferrerApply;

    mapping(uint256 => uint256) public ReferrerCode;
	
    mapping(uint256 => address) public ReferrerAddr;
	
    mapping(uint256 => address) public PartnerAddr;
	
    mapping(uint256 => address) public MMNPFPAddr;

    event NFTCreatorResult(address indexed _XContract);

    function owner() public view virtual returns (address) {
        return MMNOwner;
    }
	
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    modifier onlyExecutor() {
        require(MMNExecutor == msg.sender || owner() == msg.sender, "Ownable: caller is not the executor");
        _;
    }

    function withdraw() external onlyOwner {
		(bool success, ) = owner().call{value: address(this).balance}("");
		require(success, "Transfer failed.");
    }
	
    function PROXY() public view virtual returns (address) {
        return MMNPROXY;
    }
	
    function setPROXY(address _PROXY) external onlyOwner {
        MMNPROXY = _PROXY;
    }

    function setMMNPrice(uint _MMNPrice) external onlyOwner {
        MMNPrice = _MMNPrice;
    }
	
    function sMMNPrice() public view returns (uint256) {
        return MMNPrice;
    }

    function setReferrerRate(uint _Rate) external onlyOwner {
        require((_Rate + MMNPFPRate + ReturnRate) <= 80, "MMN: Referrer rate error.");
        ReferrerRate = _Rate;
    }
	
    function sReferrerRate() public view returns (uint256) {
        return ReferrerRate;
    }

    function setMMNPFPRate(uint _Rate) external onlyOwner {
        require((_Rate + ReferrerRate + ReturnRate) <= 80, "MMN: Referrer rate error.");
        MMNPFPRate = _Rate;
    }

    function sMMNPFPRate() public view returns (uint256) {
        return MMNPFPRate;
    }

    function setReturnRate(uint _Rate) external onlyOwner {
        require((_Rate + MMNPFPRate + ReferrerRate) <= 80, "MMN: Referrer rate error.");
        ReturnRate = _Rate;
    }

    function sReturnRate() public view returns (uint256) {
        return ReturnRate;
    }

    function IsMMNActive() public view returns (bool) {
        return MMNIsActive;
    }

    function SetMMNActive() external onlyOwner {
        MMNIsActive = !MMNIsActive;
    }

    function MMNtotalSupply() public view returns (uint256) {
        return MMNSupply;
    }
	
    function setBXImageLink(string memory _sImageLink) external onlyOwner {
		BlindboxImageLink = _sImageLink;
    }
	
    function BXImageLink() public view virtual returns (string memory) {
        return BlindboxImageLink;
    }
	
    function transferMMNOwner(uint _NFTID, address newOwner) external {
        require(msg.sender == MMNData[_NFTID].NFTOwner, "Ownable: sender is not owner.");

		iMMN(MMNData[_NFTID].NFTAddr).transferOwnership(newOwner);
		removeNFTAddr(CheckNFTIDSort(_NFTID, msg.sender), msg.sender);
		MMNData[_NFTID].NFTOwner = newOwner;

		MMNSortID[newOwner][MMNNFTAmonts[newOwner]] = _NFTID;
		MMNNFTAddr[newOwner][MMNNFTAmonts[newOwner]] = MMNData[_NFTID].NFTAddr;
		MMNNFTAmonts[msg.sender] -= 1;
		MMNNFTAmonts[newOwner] += 1;
    }
	
    function renounceMMNOwnership(uint _NFTID) external {
        require(msg.sender == MMNData[_NFTID].NFTOwner, "Ownable: sender is not owner.");

		iMMN(MMNData[_NFTID].NFTAddr).renounceOwnership();
		removeNFTAddr(CheckNFTIDSort(_NFTID, msg.sender), msg.sender);
		MMNData[_NFTID].NFTOwner = address(0);

		MMNSortID[address(0)][MMNNFTAmonts[address(0)]] = _NFTID;
		MMNNFTAddr[address(0)][MMNNFTAmonts[address(0)]] = MMNData[_NFTID].NFTAddr;
		MMNNFTAmonts[msg.sender] -= 1;
		MMNNFTAmonts[address(0)] += 1;
    }

    function IsMMNPFPAddr(address _PFPAddr) public view returns (bool) {
		bool isPFP = false;
	    for (uint i = 0; i < MMNPFPindex; i++) {
            if(MMNPFPAddr[i] == _PFPAddr){
				isPFP = true;
				return isPFP;
            }
        }
        return isPFP;
    }
	
    function sMMNPFPAddr(uint _index) public view returns (address) {
        require(_index < MMNPFPindex, "MMN: MMNPFP index error.");
        return MMNPFPAddr[_index];
    }

    function setMMNPFPAddr(uint _index, address _PFPAddr) external onlyOwner {
        require(_index < MMNPFPindex, "MMN: MMNPFP index error.");
        MMNPFPAddr[_index] = _PFPAddr;
    }

    function pushMMNPFPAddr(address _PFPAddr) external onlyOwner {
        MMNPFPAddr[MMNPFPindex] = _PFPAddr;
		MMNPFPindex += 1;
    }

    function setMMNPass(address _addr, uint _amounts) external onlyExecutor {
        MMNPass[_addr] = _amounts;
    }
	
    function IsMMNPFPOwner(address _URIAddr) public view returns (bool) {
		bool isPFPOwner = false;
	    for (uint i = 0; i < MMNPFPindex; i++) {
            if(iMMN(MMNPFPAddr[i]).balanceOf(_URIAddr) > 0){
				isPFPOwner = true;
				return isPFPOwner;
            }
        }
        return isPFPOwner;
    }

    function IsMMNPass(address _URIAddr) public view returns (bool) {
        return MMNPass[_URIAddr] > 0;
    }

    function IsNFTOwner(address _Addr) public view returns (bool) {
        return MMNNFTAmonts[_Addr] > 0;
    }

    function CheckNFTAmounts(address _Addr) public view returns (uint256) {
        return MMNNFTAmonts[_Addr];
    }

    function CheckNFTIDSort(uint _NFTID, address _Addr) public view returns (uint256) {
        require(_Addr == MMNData[_NFTID].NFTOwner, "Ownable: sender is not owner.");
        uint IDSort = 1000000;
        for(uint i = 0; i < CheckNFTAmounts(_Addr); i++) {
            if (_NFTID == MMNSortID[_Addr][i]) {
                IDSort = i;
                return IDSort;
            }
        }
        return IDSort;
    }
	
    function removeNFTAddr(uint index, address _Addr) internal returns (bool) {
        uint _NFTLength = CheckNFTAmounts(_Addr);
        require(index < _NFTLength, "Gaia : Length error.");
        for (uint i = index; i< _NFTLength - 1; i++){
            MMNSortID[_Addr][i] = MMNSortID[_Addr][i+1];
            MMNNFTAddr[_Addr][i] = MMNNFTAddr[_Addr][i+1];
        }
        return true;
    }

    function refundIfOver(uint256 price) private {
        if (msg.value > price) {
            (bool success, ) = (msg.sender).call{value: (msg.value - price)}("");
            require(success, "Transfer failed.");
        }
    }

    //----------------↓↓↓---Referrer---↓↓↓-------------------------
	
	function setReferrerCode(uint _ReferrerCode, address _addr) external onlyExecutor {
        require(!isReferrerCode(_ReferrerCode), "MMN: Referrer code already exist.");
        require(!isReferrerAddr(_addr), "MMN: Referrer address already exist.");
        ReferrerCode[ReferrerID] = _ReferrerCode;
        ReferrerAddr[ReferrerID] = _addr;
        ReferrerID += 1;
    }
	
	function ApplyReferrerCode(uint _ReferrerCode, address _addr) external {
        require(ReferrerApply[msg.sender] > 0, "MMN: Your application is not eligible.");
        require(!isReferrerCode(_ReferrerCode), "MMN: Referrer code already exist.");
        require(!isReferrerAddr(_addr), "MMN: Referrer address already exist.");	
        ReferrerCode[ReferrerID] = _ReferrerCode;
        ReferrerAddr[ReferrerID] = _addr;
        ReferrerID += 1;
		ReferrerApply[msg.sender] -= 1;
    }
	
	function modifyReferrerCode(uint _index, uint _ReferrerCode, address _addr) external onlyExecutor {
        require(!isReferrerCode(_ReferrerCode), "MMN: Referrer code already exist.");
        ReferrerCode[_index] = _ReferrerCode;
        ReferrerAddr[_index] = _addr;
    }

    function getReferrerApply() public view returns (uint256) {
        return ReferrerApply[msg.sender];
    }

    function isReferrerCode(uint _ReferrerCode) public view returns (bool) {
		bool isCode = false;
	    for (uint i = 0; i < ReferrerID; i++) {
            if(ReferrerCode[i] == _ReferrerCode){
				isCode = true;
				return isCode;
            }
        }
        return isCode;
    }
	
    function isReferrerAddr(address _Addr) public view returns (bool) {
		bool isAddr = false;
	    for (uint i = 0; i < ReferrerID; i++) {
            if(ReferrerAddr[i] == _Addr){
				isAddr = true;
				return isAddr;
            }
        }
        return isAddr;
    }
	
    function getReferrerSort(uint _ReferrerCode) public view returns (uint256) {
	    require(isReferrerCode(_ReferrerCode), "MMN: Referrer code does not exist.");
		uint ReferrerSort = 1000000;
	
	    for (uint i = 0; i < ReferrerID; i++) {
            if(ReferrerCode[i] == _ReferrerCode){
				ReferrerSort = i;
				return ReferrerSort;
            }
        }
        return ReferrerSort;
    }
	
    function getReferrer(uint _ReferrerCode) public view returns (address) {
	    require(isReferrerCode(_ReferrerCode), "MMN: Referrer Code does not exist.");
		uint ReferrerSort = getReferrerSort(_ReferrerCode);
        return ReferrerAddr[ReferrerSort];
    }

    function getReferrerCode(address _Addr) public view returns (uint256) {
	    require(isReferrerAddr(_Addr), "MMN: Referrer Code does not exist.");
		uint _ReferrerCode = 0;
	    for (uint i = 0; i < ReferrerID; i++) {
            if(ReferrerAddr[i] == _Addr){
                _ReferrerCode = ReferrerCode[i];
				return _ReferrerCode;
            }
        }
        return _ReferrerCode;
    }

    function getReferrerAddr(uint index) public view returns (uint256 _ReferrerCode, address _Addr) {
	    require(index < ReferrerID, "MMN: Referrer index does not exist.");
        return (ReferrerCode[index], ReferrerAddr[index]);
    }
	
    function IsPartnerAddr(address _PartnerAddr) public view returns (bool) {
		bool isPartner = false;
	    for (uint i = 0; i < Partnerindex; i++) {
            if(PartnerAddr[i] == _PartnerAddr){
				isPartner = true;
				return isPartner;
            }
        }
        return isPartner;
    }
	
    function sPartnerAddr(uint _index) public view returns (address) {
        require(_index < Partnerindex, "MMN: Partner index error.");
        return PartnerAddr[_index];
    }

    function setPartnerAddr(uint _index, address _PartnerAddr) external onlyOwner {
        require(_index < Partnerindex, "MMN: Partner index error.");
		require(!IsPartnerAddr(_PartnerAddr), "MMN: Already a partner.");
        PartnerAddr[_index] = _PartnerAddr;
    }

    function pushPartnerAddr(address _PartnerAddr) external onlyOwner {
		require(!IsPartnerAddr(_PartnerAddr), "MMN: Already a partner.");
        PartnerAddr[Partnerindex] = _PartnerAddr;
		Partnerindex += 1;
    }
	
    //----------------↑↑↑---Referrer---↑↑↑-------------------------

    function CreateERC721(
        uint8 tokenType,
        string memory name, 
        string memory symbol, 
        uint256 maxNftSupply, 
        uint256 saleStart, 
        uint256 saleEnd,
        uint256 _MaxPurchase,
		uint256 _ReferrerCode
	)
       external payable returns (bool)
    {
        require(IsMMNActive(), "MMN must be active to deploy NFT contract.");
        address _Sender = msg.sender;
        require(MMNNFTAmonts[_Sender] < 20, "MMN: Create too many NFT contracts.");
        require(saleEnd >= saleStart, "MMN: Mint time error.");
		address _RAddr = address(this);
		uint256 totalCost = MMNPrice;
		
        if (tokenType == 0) {
            require(IsMMNPass(_Sender), "MMNPass: MMNPass error T0.");
			MMNPass[_Sender] -= 1;
        } else {
            require(MMNPrice <= msg.value, "MMN price is not correct");
			uint _sTotalRate = 0;
			if(isReferrerCode(_ReferrerCode)) {
				_sTotalRate += ReturnRate;
				_RAddr = getReferrer(_ReferrerCode);
			}
			if(IsMMNPFPOwner(_Sender)) {
				_sTotalRate += MMNPFPRate;
			}
			totalCost = MMNPrice * (100 - _sTotalRate) / 100;
        }

		uint _mintStart = saleStart;
		uint _mintEnd = saleEnd;
        if (saleStart == 0) {
            _mintStart = block.timestamp;
        }
		
        if (saleEnd == 0) {
            _mintEnd = block.timestamp + 3153600000;
        }
		
		address _NFTAddress = iMMN(PROXY()).MMNCreateERC721(name, symbol, maxNftSupply, _mintStart, _mintEnd, _MaxPurchase, msg.sender);
        emit NFTCreatorResult(_NFTAddress);

		MMNData[MMNSupply].NFTAddr = _NFTAddress;
		MMNData[MMNSupply].NFTOwner = _Sender;
		MMNData[MMNSupply].CreatTime = block.timestamp;
		MMNData[MMNSupply].MaxNftSupply = maxNftSupply;

		MMNSortID[_Sender][MMNNFTAmonts[_Sender]] = MMNSupply;
		MMNNFTAddr[_Sender][MMNNFTAmonts[_Sender]] = _NFTAddress;
		MMNNFTAmonts[_Sender] += 1;
		MMNSupply += 1;

        if (tokenType != 0) {
            refundIfOver(totalCost);
			uint256 _payout = MMNPrice * ReferrerRate / 100;
			if(IsPartnerAddr(_RAddr)) {
				uint256 PartnerRate = ReferrerRate * 2;
				if(PartnerRate > (100 - ReturnRate - MMNPFPRate)) {
					PartnerRate = (100 - ReturnRate - MMNPFPRate);
				}
				_payout = MMNPrice * PartnerRate / 100;
			}
			
            (bool success, ) = (_RAddr).call{value: _payout}("");
            require(success, "Transfer failed.");
			ReferrerApply[_Sender] += 1;
        }
        return true;
    }
}