//
//  CoreLocationView.swift
//  Login
//
//  Created by Fernando Arana on 04/02/23.
//

import SwiftUI
import Firebase



struct CoreLocationView: View {
    
    // guarda el nombre de usuario a lo largo de su sesión
    @State var user: String
    
    // guarda el estado de sesión T/F
    @State var isLogin: Bool
    
    
    @StateObject var locationDataManager = LocationDataManager()
    @State private var paradaUno: String = ""
    @State private var paradaDos: String = ""
        
    var body: some View {
        ZStack(alignment: .center) {
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
                    
                    Button(action: {
                        ///writeToFirebase.pushNewValue(value: <#T##String#>)
                    }){
                        Text("IR")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 30)
                    }
                    .frame(width: 250, height: 40, alignment: .center)
                    .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 20)
                }
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50)
                    .padding(.top, 25)
                
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

struct CoreLocationView_Previews: PreviewProvider {
    static var previews: some View {
        let u: String = "nombre"
        let l: Bool = true
        //CoreLocationView(user: u, isLogin: l)
        CoreLocationView(user: u, isLogin: l)
    }
}
