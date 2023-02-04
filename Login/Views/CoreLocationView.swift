//
//  CoreLocationView.swift
//  Login
//
//  Created by Fernando Arana on 04/02/23.
//

import SwiftUI

struct CoreLocationView: View {
    
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                Text("Your current location is:")
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
        }
    }
}

struct CoreLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CoreLocationView()
    }
}
