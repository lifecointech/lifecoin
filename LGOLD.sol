// SPDX-License-Identifier: MIT

pragma solidity =0.8.25;
 
library SafeCast {
    /**
     * @dev Value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);

    /**
     * @dev An int value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedIntToUint(int256 value);

    /**
     * @dev Value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedIntDowncast(uint8 bits, int256 value);

    /**
     * @dev An uint value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedUintToInt(uint256 value);


    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        if (value < 0) {
            revert SafeCastOverflowedIntToUint(value);
        }
        return uint256(value);
    }


}


interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

contract Context {
    constructor() {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _owner = 0xf614ef3a59B4b834fbAf7dc2d9E492D57c1A4c25;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20Detailed {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory tname,
        string memory tsymbol,
        uint8 tdecimals
    ) {
        _name = tname;
        _symbol = tsymbol;
        _decimals = tdecimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}


contract LGOLD is Context, Ownable, IERC20, ERC20Detailed {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    using SafeCast for int256;
   

    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;
    mapping(address => bool) public _isExcludedWallet;
    mapping(address => bool) public _isBot;

    
    mapping(address => uint256) private _lastBuy;
    mapping(address => uint256) private _lastSell;

    uint256 internal _totalSupply;

    uint256 public transactionFee;   
    address public transferFeesAddress = 0xe5C77Af24E80CF0D4e7749657ba0B776237F9B09;    
    uint256 public numberOfParticipants = 0;
    uint256 public tokenSold = 0;
    uint256 public _uid = 0;
    uint256 public ltreePrice = 5*1e17; // 0.5 usdt  inital token price
    uint256 public lcarbonPrice = 75*1e16; // 0.75 usdt initial token price 

    uint256 public carbonBonusUnlockTime = 1746015152;  // April 30 2025
    uint256 public treeBonusUnlockTime = 1743989401; // April 07 2025 

    uint256 public MaxTradeLimit = 50000000 * 10**18;   

    uint256 public antiBotBuyCoolDown = 5 seconds;
    uint256 public antiBotSellCoolDown = 30 seconds;

    AggregatorV3Interface internal gold_usd_price_feed;

    bool public tradingIsEnabled = true;
    bool public limitsAreEnabled = false;
    bool public takeFee = true;
    bool public saleActive = true;
    bool public airdrop;

    event ExcludedFromTradeLimit(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    
     struct userStruct{
        bool isExist;
        uint256 investment;
        uint256 bonusLtreeToken;
        uint256 bonusLcabonToken;
        uint256 bonusLtreeLockedTime;
        uint256 bonusLcabonLockedTime;
    }    
    mapping(address => userStruct) public user;

    
    struct purchase{
        uint256 lockedAmount;
        uint256 unlockDate;
        uint256 uid;
    }
    mapping(address => purchase[]) public purchases;



    Token USDT = Token(0x55d398326f99059fF775485246999027B3197955); // USDT Address 
    Token LTREE;
    Token LCARBON;
      

    constructor() ERC20Detailed("LifeCoin Gold", "LGOLD", 18) {
        _totalSupply = 10_000_000_000 * (10**18);
        transactionFee = 5; // 5/1000 = 0.005/100 = 0.005%

        _balances[owner()] = _totalSupply;      

        _isExcludedWallet[owner()] = true;
        _isExcludedWallet[address(this)] = true;

        //gold_usd_price_feed = AggregatorV3Interface(0x4E08A779a85d28Cc96515379903A6029487CEbA0); // testnet chainlink 18 decimal
        //Fix gettokenPrice() function also for mainnet 
        gold_usd_price_feed = AggregatorV3Interface(0x86896fEB19D8A607c3b11f2aF50A0f239Bd71CD0); //mainnet chainlink  8 decimal
        emit Transfer(address(0), owner(), _totalSupply);
    }

    function getTokenPrice() public view returns(uint){
        //uint256 oneTokenPrice = ThreeHundredKiloGoldPrice().div(10000000000); // one token price = (3 hundred kg gold price) / (10 billion tokens) , testnet
        uint256 oneTokenPrice = ThreeHundredKiloGoldPrice(); // one token price = (3 hundred kg gold price) / (10 billion tokens) , mainnet
        return oneTokenPrice;
    }

    function ThreeHundredKiloGoldPrice() public view returns(uint){
        return (getCurrentGoldPriceFromChainLink().mul(964522)).div(100); // 300 KG == 9645.22 ounce
    }

    function getCurrentGoldPriceFromChainLink() public view returns(uint) {  // 1 Ounce gold price
    (
            , int price, , , 
        ) = gold_usd_price_feed.latestRoundData();

        return price.toUint256();
    }
    

    function purchaseTokensWithUSDT(uint256 amount, uint256 bonusToken) public {
        require(saleActive == true,"Sale not active!"); 
        USDT.transferFrom(msg.sender,owner(),amount);
        user[msg.sender].investment = user[msg.sender].investment + amount;
        if(!user[msg.sender].isExist){            
            user[msg.sender].isExist = true;
            numberOfParticipants = numberOfParticipants + 1;
        }
        //uint256 oneTokenPriceDecimalFix = getTokenPrice()*1e18; 
        uint256 usdt = amount;
        amount = amount * 1e18;
        uint256 usdToTokens = SafeMath.div(amount, getTokenPrice());
        uint256 tokenAmountDecimalFixed = usdToTokens;//SafeMath.div(usdToTokens,1e18);

        ////////////////////////////////////
        //user[msg.sender].lockedAmount = user[msg.sender].lockedAmount + tokenAmountDecimalFixed;

        _uid = _uid + 1;
        purchases[msg.sender].push(purchase({
            lockedAmount:tokenAmountDecimalFixed,
            unlockDate : block.timestamp + 120 days,
            uid:_uid
        }));

        tokenSold = tokenSold + tokenAmountDecimalFixed; 

        ///////////////////////// Bonus tokens
        if(bonusToken == 1){
            if(usdt >= 500000*1e18 && usdt < 1000000*1e18){
                user[msg.sender].bonusLcabonToken = user[msg.sender].bonusLcabonToken + calculateLcarbonBonus(usdt).div(20); // 5% bonus         
                user[msg.sender].bonusLcabonLockedTime = carbonBonusUnlockTime; 
            }
            else if(usdt > 1000000*1e18){
                user[msg.sender].bonusLcabonToken = user[msg.sender].bonusLcabonToken + calculateLcarbonBonus(usdt).div(10); // 10% bonus         
                user[msg.sender].bonusLcabonLockedTime = carbonBonusUnlockTime; 
            }   
        } else if(bonusToken == 2){
            if(usdt >= 500000*1e18 && usdt < 1000000*1e18){
                user[msg.sender].bonusLtreeToken = user[msg.sender].bonusLtreeToken + calculateLtreeBonus(usdt).div(20); // 5% bonus          
                user[msg.sender].bonusLtreeLockedTime = treeBonusUnlockTime;
            }
            else if(usdt > 1000000*1e18){
                user[msg.sender].bonusLtreeToken = user[msg.sender].bonusLtreeToken + calculateLtreeBonus(usdt).div(10); // 10% bonus          
                user[msg.sender].bonusLtreeLockedTime = treeBonusUnlockTime; 
            }    

        }else{
            //revert("Invalid bonus token selected!");
        }
        ///////////////////////////////////////
    }

    
    function calculateLtreeBonus(uint256 amount) public view returns(uint256){
        amount = amount * 1e18;
        uint256 usdToTokens = SafeMath.div(amount, ltreePrice);
        uint256 tokenAmountDecimalFixed = usdToTokens;//SafeMath.mul(usdToTokens,1e12);
        return tokenAmountDecimalFixed;
    }

    
    function calculateLcarbonBonus(uint256 amount) public view returns(uint256){
        amount = amount * 1e18;
        uint256 usdToTokens = SafeMath.div(amount, lcarbonPrice);
        uint256 tokenAmountDecimalFixed = usdToTokens;//SafeMath.mul(usdToTokens,1e12);
        return tokenAmountDecimalFixed;
    }
    

    function claimPurchasedTokens(uint256 index) public {
        require(index < purchases[msg.sender].length, 'Invalid index');
        purchase memory purchaseInfo = purchases[msg.sender][index];

        if(purchaseInfo.unlockDate < block.timestamp){
            _transfer(address(this), msg.sender, purchaseInfo.lockedAmount);
        }
        else{
            revert("Unlock Time not Reached!");
        }

        // Remove the stake from the array by swapping and popping
        purchases[msg.sender][index] = purchases[msg.sender][purchases[msg.sender].length - 1];
        purchases[msg.sender].pop();

    }

    function totalPurchases(address buyer) public view returns(uint256){
        if(purchases[buyer].length >0){
            return purchases[buyer].length;
        }else{
            return 0;
        }
    }
    

    function updateLtreeAddress(address ltree) public onlyOwner{
        LTREE = Token(ltree);
    }
    
    function updateLtreeTokenPrice(uint256 tokenPrice) onlyOwner public {
        ltreePrice = tokenPrice;
    }

    function updateLtreeBonusUnlockTime(uint256 newUnlockTime) public onlyOwner{
        treeBonusUnlockTime = newUnlockTime;
    }

    function updateLcarbonAddress(address lcarbon) public onlyOwner{
        LCARBON = Token(lcarbon);
    }

    function updateLcarbonTokenPrice(uint256 tokenPrice) public onlyOwner{
        lcarbonPrice = tokenPrice;
    }

    function updateLcarbonBonusUnlocktime(uint256 newUnlockTime) public onlyOwner{
        carbonBonusUnlockTime = newUnlockTime;
    }


    function claimLtreeBonusTokens() public{
        require(user[msg.sender].bonusLtreeLockedTime < block.timestamp,"Tokens will unlock on April 07 2025 ");
        require(user[msg.sender].bonusLtreeToken > 0 , "No amount to Redeem!");

        LTREE.transferFrom(address(this), msg.sender, user[msg.sender].bonusLtreeToken);
        user[msg.sender].bonusLtreeToken = 0;
    }

    function claimLcarbonBonusTokens() public{
        require(user[msg.sender].bonusLcabonLockedTime < block.timestamp,"Tokens will unlock on Feb 28 2025 ");
        require(user[msg.sender].bonusLcabonToken > 0 , "No amount to Redeem!");

        LCARBON.transferFrom(address(this), msg.sender, user[msg.sender].bonusLcabonToken);
        user[msg.sender].bonusLcabonToken = 0;
    }



    function setTransferFeesAddress(address wallet) external onlyOwner(){
        transferFeesAddress = wallet;
    }

    function mintToken(address receiver, uint256 amount) external onlyOwner(){
        _totalSupply = _totalSupply + amount;
        _balances[receiver] = _balances[receiver] + amount;
        emit Transfer(address(0), receiver, amount);
    }

    function airdropTokens(address[] calldata _recipients, uint256[] calldata amount) external onlyOwner() {
         require(_recipients.length == amount.length);
         limitsAreEnabled = false; // switch after airdrop
         airdrop = true;                                        
         for(uint i = 0; i < _recipients.length; i++){
            _transfer(msg.sender,_recipients[i], amount[i]);
         }
         airdrop = false;
    }
   
    function enableTrading() external onlyOwner() {
        require(!tradingIsEnabled, "Trading is already enabled");
        tradingIsEnabled = true;
    }

    function enableLimits(bool value) external onlyOwner() {
        limitsAreEnabled = value;
    }

    function setMaxTradeLimit(uint256 _maxTradeLimit) external onlyOwner() {
        require(_maxTradeLimit >= 1000 *10**decimals(), "Trade limit too small");
        MaxTradeLimit = _maxTradeLimit;
    }

    function excludedFromTradeLimit(address account, bool excluded) public onlyOwner() {
        require(_isExcludedWallet[account] != excluded, "Already excluded");
        _isExcludedWallet[account] = excluded;

        emit ExcludedFromTradeLimit(account, excluded);
    }

    function getIsExcludedFromTradeLimit(address account) public view returns (bool) {
        return _isExcludedWallet[account];
    }

    function addBotToList(address account) external onlyOwner() {
        require(!_isBot[account], "Account is already blacklisted");
        _isBot[account] = true;
    }

    function removeBotFromList(address account) external onlyOwner() {
        require(_isBot[account], "Account is not blacklisted");
        _isBot[account] = false;
    }

    function setAntiBotBuyCoolDown(uint256 _antiBotBuyCoolDown) external onlyOwner() {
        require(_antiBotBuyCoolDown <= 300, "Too long of cooldown");
        antiBotBuyCoolDown = _antiBotBuyCoolDown;
    }

    function setAntiBotSellCoolDown(uint256 _antiBotSellCoolDown) external onlyOwner() {
        require(_antiBotSellCoolDown <= 300, "Too long of cooldown");
        antiBotSellCoolDown = _antiBotSellCoolDown;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address towner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[towner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }
  
    //to recieve ETH 
    receive() external payable {}

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(!_isBot[sender] || !_isBot[recipient],"You are a bot");
        require(tradingIsEnabled , "Trading not started");

        if (limitsAreEnabled) {
                require(_lastBuy[recipient] + antiBotBuyCoolDown < block.timestamp, "Trying to buy too quickly");
                require(_lastSell[sender] + antiBotSellCoolDown < block.timestamp, "Trying to sell too quickly");
                require(amount <= MaxTradeLimit, "Trading too much");

                _lastSell[sender] = block.timestamp;
                _lastBuy[recipient] = block.timestamp;

        }

        //if any account belongs to _isExcludedWallet account then remove the fee
        if (_isExcludedWallet[sender] || _isExcludedWallet[recipient]) {
            takeFee = false;
        }



        if (takeFee && !airdrop) {
            uint256 txFeesAmount = amount.mul(transactionFee).div(100000); // 0.005% transaction fees
            uint256 TotalSent = amount.sub(txFeesAmount);
            _balances[sender] = _balances[sender].sub(
                amount,
                "ERC20: transfer amount exceeds balance"
            );
            _balances[recipient] = _balances[recipient].add(TotalSent);
            _balances[transferFeesAddress] = _balances[transferFeesAddress].add(txFeesAmount);
            emit Transfer(sender, recipient, TotalSent);
            emit Transfer(sender, transferFeesAddress, txFeesAmount);
        } else {
            _balances[sender] = _balances[sender].sub(
                amount,
                "ERC20: transfer amount exceeds balance"
            );
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }
    }

    function setTransactionFee(uint256 _transactionFee) public onlyOwner {
        transactionFee = _transactionFee;
    }
 

    function _approve(
        address towner,
        address spender,
        uint256 amount
    ) internal {
        require(towner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[towner][spender] = amount;
        emit Approval(towner, spender, amount);
    }
    

    function removeStuckToken(address _address) external onlyOwner {
        require(
            IERC20(_address).balanceOf(address(this)) > 0,
            "Can't withdraw 0"
        );

        IERC20(_address).transfer(
            owner(),
            IERC20(_address).balanceOf(address(this))
        );
    }

    
}

abstract contract Token {
    function transferFrom(address sender, address recipient, uint256 amount) virtual external;
    function transfer(address recipient, uint256 amount) virtual external;
    function balanceOf(address account) virtual external view returns (uint256)  ;

}