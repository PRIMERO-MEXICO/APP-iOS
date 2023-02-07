//
//  ViewModel.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 30/01/23.
//

import Foundation
import SwiftUI

// El ViewModel crea su propio modelo.
// El ViewModel funciona como gatekeeper del modelo.
// Todas las variables estan inicializadas.
// El ViewModel se comporta como un ObservableObject: es decir,
// cada que hay un cambio en el modelo, el ViewModel lo hace publico,
// si una vista esta suscrita al ViewModel, se adecua a dicho cambio.

class NavegacionViewModel: ObservableObject {
    
    // Función que inicializa el modelo.
    static func crearNavegacionModelo(_ jsonName: String) -> NavegacionModelo {
        NavegacionModelo(JSON: jsonName)
    }
    
    // Inicializamos el modelo.
    // Llamamos la funcion crearNavegacionModelo() para inicializar las variables internas de la estructura del Modelo.
    // La palabra rsv @Published nos ayuda a notificar cuando hay cambios en el modelo
    @Published private var model: NavegacionModelo = NavegacionViewModel.crearNavegacionModelo("locations")
    
    // Creamos el propio modelo para el ViewModel
    var ubicaciones: Array<NavegacionModelo.Ubicacion> {
        return model.ubicaciones
    }
    
    // Creamos el propio modelo para el ViewModel
    var checkpoints: Array<NavegacionModelo.Checkpoint> {
        get { return model.checkpoints }
    }
    
    
}
