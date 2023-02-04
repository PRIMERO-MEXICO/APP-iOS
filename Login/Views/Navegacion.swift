//
//  Navegacion.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 30/01/23.
//  MODELO

import SwiftUI
import MapKit
import UIKit

struct MapView: UIViewRepresentable {

    /// What is this for?
    typealias UIViewType = MKMapView
    
    /// -1.
    @Binding var directions: [String]
    
    /// 0. This is to receive an State which initializes the MapView in an specific Centralized Region
    @Binding var centro: MKCoordinateRegion
    
    /// 1. AnnotationOnTap is a completion to notify SwiftUI if we have clicked an annotation from MKMapView
    var annotationOnTap: (_ title: String) -> Void
 
    /// 2. @Binding is a property wrapper for checkpoints model that we need for this
    /// MapView for displaying each dot of the location.
    /// A property wrapper is essentially a type that wraps a given value in order to attach additional logic to it.
    // @Binding var checkpoints: [NavegacionModelo.Checkpoint]
    var checkpoints: [NavegacionModelo.Checkpoint]
    
    /// 3. Used internally to maintain a reference to a MKMapView
    /// instance when the view is recreated.
    let key: String

    private static var mapViewStore = [String : MKMapView]()
    
    /// 4. This one overriding function from UIViewRepresentable to return the expected view
    func makeUIView(context: Context) -> MKMapView {
        if let mapView = MapView.mapViewStore[key] {
            mapView.delegate = context.coordinator
            return mapView
        }
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        MapView.mapViewStore[key] = mapView
        mapView.setRegion(centro, animated: true)
        
        // Casa de los azulejos
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4352, longitude: -99.1412))

        // Bellas artes
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4343, longitude: -99.1402))

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile

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
            
        return mapView
    }

    /// 5. This one overriding function from UIViewRepresentable to attach a new view or
    /// do some additional layouting. In this case, we add the checkpoint to each annotation
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(checkpoints)
    }
    
    /// 6. This one also overriding function form UIViewRepresentable forcoordinator
    /// which for mapping the delegation logic on MKMapViewDelegate
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }
}


/// Okay once that view has been set up, now we can make the logic for notifying back to SwiftUI.
/// We can not apply delegate in SwiftUI, so there is a Coordinator to put the business logic layer of
/// pure Swift logic. Let make the MapCoordinator class.
final class MapCoordinator: NSObject, MKMapViewDelegate {
    
    /// 1. We need a reference to the MKMapView here for the coordinator able to return back the handler/logic we attach on it.
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }
    
    deinit {
        print("deinit: MapCoordinator")
    }
    
    /// 2. This one is the delegate function from MKMapView (Put MKMapViewDelegate on this class as well) for displaying the rightCalloutAccesoryView
    /// Tells the delegate when the user selects one or more annotations
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.canShowCallout = true

        let btn = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = btn
    }
    
    /// 3. This one is for telling if we click on the accessory control and we will return back the placeName through the handler on the MapView
    /// accessory control
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? NavegacionModelo.Checkpoint, let placeName = capital.name else { return }
        parent.annotationOnTap(placeName)
    }
    
    
    /// 4. This one is for rendering the mapView with an Overlay layout specific configurations
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}


/// Once this has been set up now we can easily use the MapView on our SwiftUI.
struct Navegacion: View {
    
    /// Inicializamos la clase NavegacionViewModel como un apuntador.
    @ObservedObject var navegacionViewModel: NavegacionViewModel
    
    /// Inicializamos la Coordenada Region Central Inicial
    @State private var coordinateRegion = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
      span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
    )
    
    ///
    @State private var directions: [String] = []
    
    ///
    @State private var showDirections = false
    
    var body: some View {
        VStack {
            MapView(directions: $directions,
                    centro: $coordinateRegion,
                    annotationOnTap: { title in
                        print("Title clicked", title)
                    },
                    checkpoints: navegacionViewModel.checkpoints,
                    key: "SearchView")
            .frame(height: UIScreen.main.bounds.height)
            
            
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

    
    
    
    
    
    

struct Navegacion_Previews: PreviewProvider {
  static var previews: some View {
      
      let viewModel = NavegacionViewModel()
      
      Navegacion(navegacionViewModel: viewModel)
  }
}
