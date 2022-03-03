pragma solidity 0.5.16;

// Este contrato permite que solo el creador del token pueda emitir o quemar
contract Ownable {
	address public _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	// Cuando el contrato se ejecute, el creador lo va a poseer (_owner)
	constructor () internal {
		_owner = msg.sender;
		emit OwnershipTransferred(address(0), msg.sender);
	}

	// Esto nos permite ver quien es el creador
	function owner() public view returns (address) {
		return _owner;
	}

	// Esto es un modificador
	// Cuando lo ponemos en una funcion, SOLAMENTE el creador la podra ejecutar
	// De otra forma, la funcion dara error
	modifier onlyOwner() {
		require(_owner == msg.sender, "No eres el creador");
		_;
	}
}

contract BasicToken is Ownable {
	// Crear variable de la cantidad total de tokens
  uint public _totalSupply;

	// Obtener el balance de una billetera
	mapping (address => uint) public _balances;

	// Esta es la funcion para transferir
	function transfer(address recipient, uint amount) public returns (bool) {
		require(msg.sender != recipient, "No puedes recibir dinero a tu misma direccion");
		require(msg.sender != address(0), "Cuenta inexistente");
		require(recipient != address(0), "Cuenta inexistente");

		_balances[msg.sender] = _balances[msg.sender] - amount;
		_balances[recipient] = _balances[recipient] + amount;

    return true;
	}

	// Funcion para emitir
	function mint(uint amount) public onlyOwner returns (bool) {
		require(msg.sender != address(0), "Cuenta inexistente");
		require(_totalSupply + amount <= 200000000, "No puedes emitir mas de 200 millones");

		_totalSupply = _totalSupply + amount;
		_balances[msg.sender] = _balances[msg.sender] + amount;

    return true;
	}

	// Funcion para quemar
	function _burn(uint amount) public onlyOwner returns (bool) {
		require(msg.sender != address(0), "Cuenta inexistente");
    require(_balances[msg.sender] >= amount, "No puedes quemar mas de lo que tienes");
	
		_balances[msg.sender] = _balances[msg.sender] - amount;
		_totalSupply = _totalSupply - amount;

    return true;
	}
}

contract ALE is BasicToken {

	string public _name;
	string public _symbol;
	uint public _decimals;

	constructor (
		string memory tokenName,
		string memory tokenSymbol,
		uint initialSupply,
		uint decimalUnits

	) public {

		_name = tokenName;
		_symbol = tokenSymbol;
		_decimals = decimalUnits;
		_totalSupply = initialSupply * (10 ** _decimals);
		_balances[msg.sender] = _totalSupply;
	}

	// Retorna los decimales
	function decimals() external view returns (uint) {
		return _decimals;
	}

	// Retorna el simbolo
	function symbol() external view returns (string memory) {
		return _symbol;
	}

	// Retorna el nombre
	function name() external view returns (string memory) {
		return _name;
	}

	// Retorna el supply
	function totalSupply() external view returns (uint) {
		return _totalSupply;
	}

	
	// Retorna el balance de una direccion
	function balanceOf(address account) external view returns (uint) {
		return _balances[account];
	}
}