//
//  Navegacion2.swift
//  Login
//
//  Created by Fernando Arana on 06/02/23.
//

import SwiftUI
import MapKit



struct Navegacion2: View {
    @ObservedObject var navegacionViewModel = NavegacionViewModel()
    @State var user: String
    @State var isLogin: Bool
    @State var tag = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Tag", text: $tag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if tag != "" {
                    NavigationLink(destination: Navegacion(user: self.user, isLogin: self.isLogin)
                        .navigationBarTitle("", displayMode: .inline)) {
                        Text("Navegar")
                    }
                }
            }
            .padding()
            .navigationBarTitle("Traza la ruta")
        }
    }
}

struct Navegacion2_Previews: PreviewProvider {
    static var previews: some View {
        let u: String = "nombre"
        let l: Bool = true
        Navegacion2(user: u, isLogin: l)
    }
}


/*
 
 // Casa de los azulejos
 let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4352, longitude: -99.1412))

 // Bellas artes
 let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4343, longitude: -99.1402))
 
 // Function that creates Direction Request
 let request = createDirectionsRequest(from: p1, to: p2)

 let Directions = MKDirections(request: request)
 Directions.calculate { response, error in
     guard let route = response?.routes.first else { return }
     mapView.addAnnotations([p1, p2])
     mapView.addOverlay(route.polyline)
     mapView.setVisibleMapRect(
         route.polyline.boundingMapRect,
         edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
         animated: true)
     self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
 }
 */
