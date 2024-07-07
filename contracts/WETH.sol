pragma solidity ^0.8.24;

contract WETH {

    string public name = 'Wrapped Ether';
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Approval(address indexed src, address indexed delegateAds, uint256 amount);
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    event Deposit(address indexed toAds, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);

    mapping(address => uint256) public balanceOf;  // 额度
    mapping(address => mapping(address =>uint256)) public allowance; // 指定地址对另一地址授权额度

    function deposit() public payable{
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] > amount);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function totalSupply() public view returns (uint256){
         return address(this).balance;
    }

    function approve(address delegateAds, uint256 amount) public returns(bool){
        allowance[msg.sender][delegateAds] = amount;
        emit Approval(msg.sender, delegateAds, amount);
        return true;
    }

    function transfer(address toAds, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, toAds, amount);
    }

    function transferFrom(address Src, address Dst, uint256 amount) public returns(bool){
        require(balanceOf[Src] >= amount);
        if (Src != msg.sender){
            require(allowance[Src][msg.sender] >= amount);
            allowance[Src][msg.sender] -= amount;
        }
        balanceOf[Src] -= amount;
        balanceOf[Dst] += amount;
        emit Transfer(Src, Dst, amount);
        return true;
    }
    
    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
    
}