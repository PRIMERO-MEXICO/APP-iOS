//
//  ContentView.swift
//  Login
//
//  Created by Isai Ambrocio on 26/01/23.
//

import SwiftUI
import Firebase

struct AuthContentView: View {
    
    // @ObservedObject var viewModel: NavegacionViewModel
    
    var body: some View {
        NavigationStack {
            Login()
        }
    }
}

struct Login: View{
    
    @State var user: String = ""
    @State var passwd = ""
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @State var alert = false
    @State var error = ""
    
    // Mantiene estado para verificar si un usuario inició sesión
    @State var isLogin = false
    
    var body: some View{
        if isLogin {
            Navegacion2(user: self.user, isLogin: self.isLogin)
            // Main(user: self.user, isLogin: true)
        } else {
            ZStack{
                ZStack(alignment: .center){
                    // Imágen de fondo del Login y sus propiedades.
                    Fondo()
                    
                    VStack{
                        // Logo de Primero México y sus propiedades.
                        Image("LogoPM")
                            .resizable()
                            .frame(width: 250, height: 250)
                        
                        // Textos de bienvenida
                        Text("Bienvenido")
                            .font(.title2)
                            .foregroundColor(self.color)
                            .padding(.top, 30)
                        
                        Text("Ingresa tus datos para continuar")
                            .foregroundColor(self.color)
                        
                        // Campo de texto para ingresar el usuario.
                        TextField(" Usuario", text: self.$user)
                            .frame(width: 250, height: 40, alignment: .center)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 6))
                            .padding(.top, 10)
                        
                        // Área de botones.
                        HStack(spacing: 15){
                            VStack{
                                // Campo de texto para ingresar la contraseña.
                                if self.visible{
                                    TextField("", text: self.$passwd)
                                }
                                else{
                                    SecureField("Contraseña", text: self.$passwd)
                                }
                            }
                            // Botón para revelar u ocultar la contraseña.
                            Button(action: {
                                self.visible.toggle()
                            }){
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .frame(width: 250, height: 40, alignment: .center)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 6))
                        .padding(.top, 10)
                        
                        // Botón para iniciar sesión.
                        Button(action: {
                            self.verify()
                        }){
                            Text("Iniciar Sesión")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 30)
                        }
                        .frame(width: 250, height: 40, alignment: .center)
                        .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 25)
                }
                
                if self.alert{
                    LoginError(alert: self.$alert, error: self.$error)
                }
            }
        }
    }

    func verify(){
        if self.user != "" && self.passwd != ""{
            
            self.access(user: user, passwd: passwd){ (success) in
                if (success) {
                    print("entraste")
                    self.isLogin.toggle()
                } else {
                    self.error = "El usuario o la contraseña es incorrecta."
                    self.alert.toggle()
                }
            }
        }
        else {
            self.error = "Por favor llene todos los campos para iniciar sesión"
            self.alert.toggle()
        }
    }
    
    func access(user: String, passwd: String, completionBlock: @escaping(_ success: Bool)->Void){
        Auth.auth().signIn(withEmail: user, password: passwd) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            }
            else{
                completionBlock(false)
            }
        }
    }
}

struct LoginError: View{
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    Text("Problema al iniciar sesión")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red.opacity(0.8))
                }
                .padding(.horizontal, 70)
                
                Text(self.error)
                    .padding(.top, 5)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                    
                }){
                    Text("Entiendo")
                        .foregroundColor(Color.white)
                        .frame(width: 250, height: 40, alignment: .center)
                }
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(6)
                    .padding(.top, 15)
                    
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(25)
            
        }
        .padding(.vertical, 280)
        .padding(.horizontal, 40)
        .background(Color.black.opacity(0.7).edgesIgnoringSafeArea(.all))

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        // let viewModel = NavegacionViewModel()
        
        //AuthContentView(viewModel: viewModel)
        AuthContentView()

    }
}
