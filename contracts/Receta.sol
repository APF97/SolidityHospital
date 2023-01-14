// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";

contract Receta is ERC721 {
    
    //Declaramos el numero de nuestro token.
    uint256 private tokenID;
        
    //Definimos la estructura de nuestra receta    
    struct Recet {
        uint256 UIM;
        uint256 tokenID;
        string nombre;
        string estado;
        address _direccionP;
        address _direccionM;
    }

    //Mapping para saber en que estado se encuentra una receta.
    mapping (uint256 => string) EstadoReceta;

    //Array de receta.
    Recet[] public recetas;

    //Creamos un tokenERC721 con su ID a 0.
    constructor() ERC721("Receta", "RCT") {
        tokenID = 0;
    }
    
    //Funcion para crear la receta, en esta funcion se crea el token.
    function crReceta(address _to , uint256 _UIM, string memory _nombre) external {
        EstadoReceta[tokenID] = "Receta creada";
        _safeMint(_to, tokenID);
        recetas.push(Recet(_UIM, tokenID, _nombre, EstadoReceta[tokenID] , _to, msg.sender));
        tokenID++;
    }
    
    //Funcion para consultar los datos de una receta.
    function consultarReceta(uint256 _tokenID) external view returns(uint256, string memory, string memory, address){
       uint256 _UIM = recetas[_tokenID].UIM;
       string memory _nombre = recetas[_tokenID].nombre;
       string memory _estado = EstadoReceta[_tokenID];
       address _paciente = recetas[_tokenID]._direccionP;

       return(uint256(_UIM),string(_nombre), string(_estado), address(_paciente));
    }

    //Funcion para enviar el token a la farmacia.
    function enviarToken(uint256 _tokenID, address _to, address _from) external {
      transferFrom(_from, _to, _tokenID);
      EstadoReceta[_tokenID] = "Enviada a la farmacia";
    }
    
    //Funcion para quemar el token de una receta.
    function quemarReceta(uint256 _tokenID) external {
        _burn(_tokenID);
        EstadoReceta[_tokenID] = "Medicamentos entregados";
    }


   /* function getEstadoReceta(_tokenID) external return(string) {
        return(EstadoReceta[_tokenID]);
    }*/

    

}