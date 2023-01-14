// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Hospital.sol";
import "./Receta.sol";

contract Paciente {
    //Declaramos los contratos de los cuales usaremos funciones.
    Receta TokenReceta;
    Hospital hospital;
    
    //Precio de la receta.
    uint recetaFee = 10 ether;

    
    modifier _onlyPaciente() {
        require(hospital.isPaciente(msg.sender), "No eres un paciente");
        _;
    }
    

    constructor(address _direccionHospital, address _direccionReceta){
        hospital = Hospital(_direccionHospital);
        TokenReceta = Receta(_direccionReceta);
    }

    //Enviamos la receta a la farmacia.
    function enviarReceta(uint256 _tokenID, address payable _toFarm) public payable _onlyPaciente(){
        _toFarm.transfer(recetaFee);
        TokenReceta.enviarToken(_tokenID, _toFarm, msg.sender);
    }
         

}