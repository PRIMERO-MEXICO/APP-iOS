//
//  Navegacion.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 30/01/23.
//  MODELO

import SwiftUI
import MapKit
import UIKit
import Firebase



struct mapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, user: self.usuario, uid: self.uid)
    }
    
    @State var uid: String
    @State var usuario: String
    @State var isLogin: Bool
    var checkpoints: [NavegacionModelo.Checkpoint]
    var centro: MKCoordinateRegion
    @State var paradaUno: MKMapItem
    @State var paradaDos: MKMapItem


    var manager = CLLocationManager()
    
    // MARK: - CONFORMING TO UIVIEWREPRESENTABLE
    /// 4. This one overriding function from UIViewRepresentable to return the expected view
    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        map.delegate = context.coordinator
        
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        map.showsUserLocation = true
        manager.requestWhenInUseAuthorization()
        map.setRegion(centro, animated: true)
        
        
        // Dirección 1
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (self.paradaUno.placemark.location?.coordinate.latitude)!, longitude: (self.paradaUno.placemark.location?.coordinate.longitude)!))

        // Dirección 2
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (self.paradaDos.placemark.location?.coordinate.latitude)!, longitude: (self.paradaDos.placemark.location?.coordinate.longitude)!))
        
        
        // Function that creates Direction Request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        // createDirectionsRequest(from: p1, to: p2)

        let Directions = MKDirections(request: request)
        
        Directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            map.addAnnotations([p1, p2])
            map.addOverlay(route.polyline)
            map.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(checkpoints)
    }
    

    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        
        var parent: mapView
        var user: String
        var uid: String
        
        init(parent: mapView, user: String, uid: String) {
            self.parent = parent
            self.user = user
            self.uid = uid
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse:
                //authorizationStatus = .authorizedWhenInUse
                //locationManager.requestLocation()
                break
                
            case .restricted, .denied:
                //authorizationStatus = .denied
                break
                
            case .notDetermined:
                //authorizationStatus = .notDetermined
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let last = locations.last

            //print(last?.coordinate.latitude)
            
            let ref: DatabaseReference! = Database.database().reference()
            ref.child("Users").child(self.uid).child("latitud").setValue(last?.coordinate.latitude.description)
            ref.child("Users").child(self.uid).child("longitud").setValue(last?.coordinate.longitude.description)
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}





/// Once this has been set up now we can easily use the MapView on our SwiftUI.
struct Navegacion: View {

    @ObservedObject var navegacionViewModel = NavegacionViewModel()
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    
    @State var uid: String
    @State var user: String
    @State var isLogin: Bool
    @State var paradaUno: MKMapItem
    @State var paradaDos: MKMapItem
    @State var centro: MKCoordinateRegion

    
    var body: some View {
        VStack {
            mapView(directions: $directions,
                    uid: self.uid,
                    usuario: self.user,
                    isLogin: self.isLogin,
                    checkpoints: navegacionViewModel.checkpoints,
                    centro: self.centro,
                    paradaUno: self.paradaUno,
                    paradaDos: self.paradaDos)
            
            Button(action: {
                self.showDirections.toggle()
            }, label: {
                Text("Show directions")
            })
            .disabled(directions.isEmpty)
            .padding()
            }.sheet(isPresented: $showDirections, content: {
                VStack(spacing: 0) {
                    Text("Directions")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    Divider().background(Color(UIColor.systemBlue))

                    List(0..<self.directions.count, id: \.self) { i in
                        Text(self.directions[i]).padding()
                    }
                }
            })
        }
}

/// referencias: https://medium.com/macoclock/mapview-swiftui-with-annotationview-and-coordinator-70a305cf657

    
    
    
func createDirectionsRequest(from coordinateFrom: MKPlacemark!, to coordinateTo: MKPlacemark!) -> MKDirections.Request {
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: coordinateFrom)
    request.destination = MKMapItem(placemark: coordinateTo)
    request.transportType = .automobile
    request.requestsAlternateRoutes = true
    
    return request
}





    
    /*

     struct Navegacion_Previews: PreviewProvider {
       static var previews: some View {
           
           let u: String = "nombre"
           let l: Bool = true
           let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4352, longitude: -99.1412))

           let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4343, longitude: -99.1402))
           Navegacion(user: u, isLogin: l)
       }
     }
*/
