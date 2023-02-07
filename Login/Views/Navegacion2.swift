//
//  Navegacion2.swift
//  Login
//
//  Created by Fernando Arana on 06/02/23.
//

import SwiftUI
import MapKit
import Combine


struct Navegacion2: View {
    @ObservedObject var navegacionViewModel = NavegacionViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    @State var uid: String
    @State var user: String
    @State var isLogin: Bool
    @State var tag = ""
    @State private var paradaUno: String = ""
    @State private var paradaDos: String = ""
    @State var tmpMKMapItem: MKMapItem
    @State var tmpMKMapItem2: MKMapItem
    
    var body: some View {
        NavigationView {
            if isLogin {
                ZStack {
                    Fondo()
                    
                    VStack {
                        // HEADER
                        HStack {
                            Spacer()
                            Image("LogoPM")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .padding(.horizontal, -10)
                            VStack {
                                Image("memoji")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().stroke(.white, lineWidth: 2)
                                    }
                                    .shadow(radius: 5)
                                ZStack {
                                    Rectangle()
                                        .frame(width: 60, height: 20)
                                        .cornerRadius(50)
                                        .foregroundColor(.black)
                                        .opacity(0.245)
                                    
                                    Text(self.user)
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        .padding(.top, 80)
                        .padding(.bottom, 80)
                        
                        
                        // BODY
                        VStack {
                            // UBICACIÓN INICIAL DEL USUARIO
                            switch locationDataManager.locationManager.authorizationStatus {
                            case .authorizedWhenInUse:
                                Text("Tu ubicación actual es:")
                                Text("\(locationDataManager.CampoDeTextoOrigen!)")
                                Text("Latitud: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error de carga")")
                                Text("Longitud: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error de carga")")
                            case .restricted, .denied:
                                Text("El acceso a la ubicación actual fue denegada.")
                            case .notDetermined:
                                Text("Encontrando tu ubicación...")
                                ProgressView()
                            default:
                                ProgressView()
                            }
                            
                            // PARADA 1 y PARADA 2
                            
                            TextField("Marcador de tu ubicación", text: $tag)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .padding(.top, 20)
                            
                            if String(tmpMKMapItem.name!) == "Unknown Location" {
                                TextField("Primer parada", text: $paradaUno)
                                    .disableAutocorrection(true)
                                    .padding(.bottom, 10)
                                
                            } else {
                                Text("\(tmpMKMapItem.name!)")
                                    .padding(.bottom, 10)
                            }
                            
                            if paradaUno != "", String(tmpMKMapItem.name!) == "Unknown Location" {
                                if String(tmpMKMapItem2.name!) != "Unknown Location" {
                                    NavigationLink(destination: Busqueda(uid: self.uid,
                                                                         user: self.user,
                                                                         isLogin: self.isLogin,
                                                                         tmpMKMapItem: MKMapItem(),
                                                                         tmpMKMapItem2: self.tmpMKMapItem2)
                                        .navigationBarTitle("", displayMode: .inline)) {
                                            Text("Buscar")
                                                .frame(width: 250, height: 40, alignment: .center)
                                                .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                                                .padding(.top, -5)
                                                .foregroundColor(.white)
                                        }
                                } else {
                                    NavigationLink(destination: Busqueda(uid: self.uid,
                                                                         user: self.user,
                                                                         isLogin: self.isLogin,
                                                                         tmpMKMapItem: MKMapItem(),
                                                                         tmpMKMapItem2: MKMapItem())
                                        .navigationBarTitle("", displayMode: .inline)) {
                                            Text("Buscar")
                                                .frame(width: 250, height: 40, alignment: .center)
                                                .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                                                .padding(.top, -5)
                                                .foregroundColor(.white)
                                        }
                                }
                            }
                            
                            if String(tmpMKMapItem2.name!) == "Unknown Location" {
                                TextField("Segunda parada", text: $paradaDos)
                                    .disableAutocorrection(true)
                                    .padding(.bottom, 10)
                                
                            } else {
                                Text("\(tmpMKMapItem2.name!)")
                                    .padding(.bottom, 10)
                            }
                            
                            if paradaDos != "", String(tmpMKMapItem2.name!) == "Unknown Location" {
                                if String(tmpMKMapItem.name!) != "Unknown Location" {
                                    NavigationLink(destination: Busqueda(uid: self.uid,
                                                                         user: self.user,
                                                                         isLogin: self.isLogin,
                                                                         tmpMKMapItem: self.tmpMKMapItem,
                                                                         tmpMKMapItem2: MKMapItem())
                                        .navigationBarTitle("", displayMode: .inline)) {
                                            Text("Buscar")
                                                .frame(width: 250, height: 40, alignment: .center)
                                                .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                                                .padding(.top, -5)
                                                .foregroundColor(.white)
                                        }
                                } else {
                                    NavigationLink(destination: Busqueda(uid: self.uid,
                                                                         user: self.user,
                                                                         isLogin: self.isLogin,
                                                                         tmpMKMapItem: MKMapItem(),
                                                                         tmpMKMapItem2: MKMapItem())
                                        .navigationBarTitle("", displayMode: .inline)) {
                                            Text("Buscar")
                                                .frame(width: 250, height: 40, alignment: .center)
                                                .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                                                .padding(.top, -5)
                                                .foregroundColor(.white)
                                        }
                                }
                            }
                            
                            
    if tag != "" {
        NavigationLink(destination: Navegacion(uid: self.uid,
                                                user: self.user,
                                                isLogin: self.isLogin,
                                                paradaUno: self.tmpMKMapItem,
                                                paradaDos: self.tmpMKMapItem2,
                                                centro: MKCoordinateRegion(
                                                center: CLLocationCoordinate2D(latitude: (self.locationDataManager.locationManager.location?.coordinate.latitude)!, longitude: (self.locationDataManager.locationManager.location?.coordinate.longitude)!),
                                                span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
                                                ))
            .navigationBarTitle("", displayMode: .inline)) {
                Text("Navegar")
                    .frame(width: 250, height: 40, alignment: .center)
                    .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 20)
                    .foregroundColor(.white)
            }
    }
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 50)
                        .padding(.top, -45)
                        
                        Spacer()
                        
                        // FOOTER
                        Button(action: {
                            self.isLogin.toggle()
                        }){
                            Text("Cerrar Sesión")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 30)
                        }
                        .frame(width: 250, height: 40, alignment: .center)
                        .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                        .padding(.bottom, 90)
                    }
                }
            } else {
                AuthContentView()
            }
        }
    }
}

struct Navegacion2_Previews: PreviewProvider {
    static var previews: some View {
        let uid = "wFN8MaVR6BYt0CbFRVg4161agLJ2"
        let u: String = "nombre"
        let l: Bool = true
        let tmp = MKMapItem()
        let tmp2 = MKMapItem()
        Navegacion2(uid: uid, user: u, isLogin: l, tmpMKMapItem: tmp, tmpMKMapItem2: tmp2)
    }
}
