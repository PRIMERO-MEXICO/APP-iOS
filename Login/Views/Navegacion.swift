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
    
    @State var uid: String
    @State var usuario: String
    @State var isLogin: Bool
    var checkpoints: [NavegacionModelo.Checkpoint]
    // ubicación inicial centro cdmx
    var centro: MKCoordinateRegion
    
    @State var paradaUno: String
    @State var paradaDos: String
    @State var directions: [String] = []
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, user: self.usuario, uid: self.uid)
    }
    
    let map = MKMapView()
    var manager = CLLocationManager()
    
    // MARK: - CONFORMING TO UIVIEWREPRESENTABLE
    /// 4. This one overriding function from UIViewRepresentable to return the expected view
    func makeUIView(context: Context) -> MKMapView {
        
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        map.showsUserLocation = true
        manager.requestWhenInUseAuthorization()
        map.setRegion(centro, animated: true)
        
        
        // Casa de los azulejos
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4352, longitude: -99.1412))

        // Bellas artes
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4343, longitude: -99.1402))
        
        var P1 = MKMapItem()
        var P2 = MKMapItem()
        
        let searchRequestParadaUno = MKLocalSearch.Request()
        searchRequestParadaUno.naturalLanguageQuery = self.paradaUno
        
        let searchRequestParadaDos = MKLocalSearch.Request()
        searchRequestParadaDos.naturalLanguageQuery = self.paradaDos
        
        let search1 = MKLocalSearch(request: searchRequestParadaUno)
        let search2 = MKLocalSearch(request: searchRequestParadaDos)
        
        search1.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            P1 = response.mapItems.last!
        }
        
        search2.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            P2 = response.mapItems.last!
        }
        
        // Function that creates Direction Request
        let request = createDirectionsRequest(from: P1.placemark, to: P2.placemark)

        let Directions = MKDirections(request: request)
        

        
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(checkpoints)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
    

}

class Coordinator: NSObject, CLLocationManagerDelegate {
    
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
}



/// Once this has been set up now we can easily use the MapView on our SwiftUI.
struct Navegacion: View {

    @ObservedObject var navegacionViewModel = NavegacionViewModel()
    @State private var directions: [String] = []
    @State private var showDirections = false
    @State var uid: String
    @State var user: String
    @State var isLogin: Bool
    @State var paradaUno: String
    @State var paradaDos: String
    @State var centro: MKCoordinateRegion

    
    var body: some View {
        VStack {
            mapView(uid: self.uid,
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
