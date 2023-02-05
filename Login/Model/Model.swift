//
//  Model.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 30/01/23.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

struct NavegacionModelo {
    
    // Ubicaciones es el arreglo de las unidades 'Ubicacion'
    // Esta variable tiene acceso de vista para otras class y struct's
    private(set) var ubicaciones: [Ubicacion]
    
    // Ubicaciones con compliance para MKAnnotation
    var checkpoints: [Checkpoint]
    
    // JSONData es el arreglo aux para el JSON Decoder
    struct JSONData: Decodable {
        let locations: [Ubicacion]
    }

    /// Initializer para el modelo. Queremos inicializar la propiedad arreglo ubicaciones.
    /// Los parametros son: el nombre del JSON. Los parametros los pasamos desde el ViewModel.
    init(JSON jsonName: String) {
        
        ubicaciones = Array<NavegacionModelo.Ubicacion>()
        checkpoints = Array<NavegacionModelo.Checkpoint>()
        
        if let url = Bundle.main.url(forResource: jsonName, withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(JSONData.self, from: data) {
                ubicaciones = jsonData.locations
                
                ubicaciones.forEach { ubi in
                    let cp = Checkpoint(name: ubi.name,
                                        latitud: ubi.latitude,
                                        longitud: ubi.longitude)
                    checkpoints.append(cp)
                }
            }
        }
    }
    
    // Ubicacion es la 'unidad'
    struct Ubicacion: Decodable, Identifiable {
        let id: Int
        let name: String
        let latitude: Double
        let longitude: Double
        // let coordinate: CLLocationCoordinate2D
    }
    
    /// MKAnnotation: an interface for associating your content with a specific map location
    final class Checkpoint: NSObject, MKAnnotation {
        let name: String?
        let coordinate: CLLocationCoordinate2D
        
        init (name: String?, latitud: Double?, longitud: Double?) {
            self.name = name
            self.coordinate = CLLocationCoordinate2D(latitude: latitud!, longitude: longitud!)
        }
    }
}
