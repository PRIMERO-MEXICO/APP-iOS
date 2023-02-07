//
//  Main.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 29/01/23.
//

import SwiftUI

// View para Main
struct Main: View {

    @State var user: String
    @State var isLogin: Bool
    
    var body: some View {
        if isLogin {
            ZStack(alignment: .center) {
                Fondo()
                VStack {
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
                    
                    
                    Spacer()
                    
                    // Botón para cerrar sesión.
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
        } else {
            AuthContentView()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        let u: String = "nombre"
        let l: Bool = true
        Main(user: u, isLogin: l)
    }
}
