// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Hospital.sol";
import "./Receta.sol";

contract Farmacia {
   
    //Declaramos los contratos de los cuales de van a usar funciones.
    Hospital hospital;
    Receta TokenReceta;

    //Defino lo que va a pagar la farmacia al hospital por haberle enviado un paciente.
    uint _hospitalFee = 5 ether;

    constructor(address _direccionHospital, address _direccionReceta){
        hospital = Hospital(_direccionHospital);
        TokenReceta = Receta(_direccionReceta);
    }
 
    //Modificador para que solo las farmacias puedan usar algunas funciones.
    modifier _onlyFarmacia(){
        require(hospital.isFarmacia(msg.sender), "Solo las Farmacias pueden hacer esta funcion.");
        _;
    }
    
    //Funcion para consultar las recetas.
    function verRecetas(uint256 _tokenID) public view _onlyFarmacia() {
       TokenReceta.consultarReceta(_tokenID);
    }

    //Funcion para poder cambiar las recetas por medicamentos y así poder quemar el token.
    function canjearReceta(uint256 _tokenID, address payable _hospital) public _onlyFarmacia() payable{
        _hospital.transfer(_hospitalFee);
        TokenReceta.quemarReceta(_tokenID);
    }
}