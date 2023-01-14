// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Hospital.sol";
import "./Receta.sol";

contract Doctor {
    
    //Declaramos los contratos de los cuales usamos funciones.
    Receta TokenReceta;
    Hospital hospital;


    constructor(address _direccionHospital, address _direccionReceta){
        hospital = Hospital(_direccionHospital);
        TokenReceta = Receta(_direccionReceta);
    }
  
   //Modificador para que solo puedan usar los medicos las funciones.
    modifier _onlyMedico() {
        require(hospital.isMedico(msg.sender), "Solo los medicos pueden crear recetas.");
        _;
    }
    
    //Funcion para crear una receta.
    function crearReceta(address _direccionP, uint256 _UIM, string memory _nombre) public _onlyMedico() {
        TokenReceta.crReceta(_direccionP, _UIM, _nombre);
    }

}