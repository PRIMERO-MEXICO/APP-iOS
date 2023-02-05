//
//  CoreLocationView.swift
//  Login
//
//  Created by Fernando Arana on 04/02/23.
//

import SwiftUI

struct CoreLocationView: View {
    
    @StateObject var locationDataManager = LocationDataManager()
    @State private var paradaUno: String = ""
    @State private var paradaDos: String = ""
    
    var body: some View {
        VStack {
            
            // UBICACIÓN INICIAL DEL USUARIO
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                Text("Your current location is:")
                // cuando esto esté sucediendo queremos guardar en FireBase las coordenadas: latitude & longitude
                Text("\(locationDataManager.CampoDeTextoOrigen!)")
                
                Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                
                Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
    
            case .restricted, .denied:
                Text("Current location data was restricted or denied.")
            case .notDetermined:
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
            
            // PARADA 1 y PARADA 2
            VStack {
                TextField(
                    "Primer parada",
                    text: $paradaUno
                )
                .disableAutocorrection(true)
                .padding(.bottom, 10)
                TextField(
                    "Segunda parada",
                    text: $paradaDos
                )
                .disableAutocorrection(true)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 50)
            .padding(.top, 25)
            
        }
    }
}

struct CoreLocationView_Previews: PreviewProvider {
    static var previews: some View {
        
        CoreLocationView()
    }
}
