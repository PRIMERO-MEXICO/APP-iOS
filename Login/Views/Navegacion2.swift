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
    @StateObject var locationDataManager = LocationDataManager()
    @State var user: String
    @State var isLogin: Bool
    @State var tag = ""
    @State private var paradaUno: String = ""
    @State private var paradaDos: String = ""
    
    var body: some View {
        NavigationView {
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
                        
                        TextField("Primer parada", text: $paradaUno)
                            .disableAutocorrection(true)
                            .padding(.bottom, 10)
                        
                        TextField("Segunda parada", text: $paradaDos)
                            .disableAutocorrection(true)
                        
                        if tag != "" {
                            NavigationLink(destination: Navegacion(user: self.user, isLogin: self.isLogin)
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
                    .padding(.top, 15)
                    
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
                    .padding(.bottom, 30)
                }
            }
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
