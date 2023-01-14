// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "./Receta.sol";
import "./Doctor.sol";
import "./Paciente.sol";
import "./Farmacia.sol";

contract Hospital is Ownable{
    
    //Declaramos la dirección de la receta.
    address RecetaContractAddress;
    
    //Declaramos los contratos que vamos a deployear mas adelante.
    Doctor DoctorsContract;
    Paciente PacientesContract;
    Farmacia FarmaciaContract;

    
    //En este contructor creamos el token receta dentro de Hospital.
    constructor(address _RecetaContractAddress){
        RecetaContractAddress = _RecetaContractAddress;
    }

    //Esta funcion desplega los contratos que hemos declarado anteriormente.
    function deployContracts() public onlyOwner returns(address,address,address){
        DoctorsContract = new Doctor(address(this), RecetaContractAddress);
        PacientesContract = new Paciente(address(this), RecetaContractAddress);
        FarmaciaContract = new Farmacia(address(this), RecetaContractAddress);

        return(address(DoctorsContract), address(PacientesContract), address(FarmaciaContract));
    }



    //Aqui se define la estructura de Medico.
    struct Medico {
        uint256 DNIm;
        string nombreM;
        string Especialidad;
        address direccionM;
    }
    
    //Mappings que usamos para ver si un medico o farmacia existen.
    mapping (address => bool) public Lista_Medicos;
    mapping (address => bool) public Lista_Farmacias;
    mapping (address => bool) public Lista_Pacientes;
  
    //Modificador que usaremos en funciones que solo pueda usar un medico.
    modifier onlyMedico(address _M) {
        require(Lista_Medicos[_M]);
        _;
    }
 
    //Esta funcion funciona como un get para poder usar el anterior modificador en otros contratos.
    function isMedico(address _address) external view returns(bool){
        return Lista_Medicos[_address];
    }
    
   //Modificador que usaremos en funciones que solo pueda usar una Farmacia.
    modifier onlyFarmacia(address _F) {
        require(Lista_Farmacias[_F]);
        _;
    }
    
    //Esta funcion funciona como un get para poder usar el anterior modificador en otros contratos.
    function isFarmacia(address _address) external view returns(bool){
        return Lista_Farmacias[_address];
    }

      //Modificador que usaremos en funciones que solo pueda usar un paciente.
    modifier onlyPaciente(address _P) {
        require(Lista_Pacientes[_P]);
        _;
    }
 
    //Esta funcion funciona como un get para poder usar el anterior modificador en otros contratos.
    function isPaciente(address _address) external view returns(bool){
        return Lista_Pacientes[_address];
    }
    

    //Estructura de persona.
    struct Persona {
        uint256 DNIp;
        string nombreP;
        address direccionP;
    }
    
    //Estructura de Farmacia.
    struct Farma {
        string nombreF;
        address direccionF;
    }

    //Arrays donde se guardaran los distintos medicos, pacientes y farmacias.
    Medico[] public medicos;
    Persona[] public pacientes;
    Farma[] public farmacias;

    //Funcion para crear pacientes y guardarlos en el array.
    function crearPaciente(uint256 _DNIp, string memory _nombreP, address _direccionP) public onlyOwner(){
        pacientes.push(Persona(_DNIp, _nombreP, _direccionP));
        Lista_Pacientes[_direccionP] = true;
    }
 
    //Misma funcionalidad que la anterior funcion pero para medicos.
    function crearMedico(uint256 _DNIm, string memory _nombreM, string memory _especialidad, address _direccionM) public onlyOwner(){
        medicos.push(Medico(_DNIm, _nombreM, _especialidad, _direccionM));
        Lista_Medicos[_direccionM] = true;
    }

    //Misma funcionalidad que la anterior funcion pero para Farmacias.
    function crearFarmacia(string memory _nombreF, address _direccionF) public onlyOwner(){
        farmacias.push(Farma(_nombreF, _direccionF));
        Lista_Farmacias[_direccionF] = true;
    }
    
}