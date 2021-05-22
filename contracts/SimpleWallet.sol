pragma solidity ^0.8.4;
import "./Allowance.sol";

contract SampleWallet is Allowance {
    event MoneySent(address _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) payable {
        require(_amount <= address(this).balance, "There are not enough funds in this smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }

        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() override public pure {
        revert("Not allowed to renounce ownership");
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    fallback() external payable {

    }
}