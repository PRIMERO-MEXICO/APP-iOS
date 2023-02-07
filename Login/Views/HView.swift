//
//  HView.swift
//  Login
//
//  Created by Patricio Bosque on 06/02/23.
//

import Foundation
import SwiftUI
import MapKit

struct HView: View {
    
    @ObservedObject var navegacionViewModel = NavegacionViewModel()
    @State var user: String
    @State var isLogin: Bool
    @State var uid: String
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Image("Fondo1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                Image("Logo 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210.0, height: 150.0, alignment: .center)
                    .offset(x: 9, y: -300)
                
                NavigationLink(destination: AuthContentView()) {
                    UserButton()
                }
                .offset(x: 125, y:-325)
                
                VStack(spacing: 200) {
                    HStack(spacing: 90) {
                        
                        
                        InfoRelevanteView()
                        
                        
                        NavigationLink(destination: ComingSoonView()) {
                            MenuDesign(text: "historial de recorridos", icon: "figure.walk.diamond", color: Color(red: 156 / 255, green: 223 / 255, blue: 183 / 255))
                            
                        }
                        .offset(y: -90)
                        .frame(width: 100, height: 50)
                        
                    }
                }
                HStack(spacing: 90) {
                    
                    NavigationLink(destination: ComingSoonView()) {
                        MenuDesign(text: "SOS", icon: "phone", color: Color(red: 255 / 255, green: 102 / 255, blue: 102 / 255))
                        
                    }
                    .offset(y: 170)
                    .frame(width: 100, height: 50)
        
                    
                    NavigationLink(destination: Navegacion2(uid: self.uid,
                                                            user: self.user,
                                                            isLogin: self.isLogin, tmpMKMapItem: MKMapItem(), tmpMKMapItem2: MKMapItem())
                                                           ){
                        MenuDesign(text: "rutas de traslado", icon: "mappin.square", color: Color(red: 255 / 255, green: 255 / 255, blue: 204 / 255))
                        
                    }
                    .offset(y: 170)
                    .frame(width: 100, height: 50)
                    
                }
            }
        }
    }
            //.navigationBarTitle("Buttons Grid")
}

struct MenuDesign: View{
    
    var text: String
    var icon: String
    var color: Color
    
    var body: some View{
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
                .scaleEffect(2)
                .offset(x: 55 ,y: -40)
                .font(.title)
                .padding(.bottom, 70)
            Text(text)
                .padding()
                .background(Circle()
                    .fill(color)
                    .frame(width: 110, height: 110)
                )
                .frame(width: 100, height: 100)
            
                .padding(.bottom, 6)
            //.frame(width: 100, height: 100)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .offset(x: -22, y: 50)
                .padding(.bottom, 22)
        }
        .frame(width: 130, height: 200)
        .padding()
        .shadow(radius: 5)
        .background(Color(white: 0.96))
        .cornerRadius(20)
        
    }
    
    }

struct UserButton: View {

   var icon = "person.crop.circle"

   var body: some View {
      return HStack {
         Image(systemName: icon)
            .foregroundColor(.primary)
      }
      .frame(width: 50, height: 50)
      .background(Color(red: 255 / 255, green: 204 / 255, blue: 153 / 255))
      .cornerRadius(30)
   }
}

struct InfoRelevanteView: View {
    @State private var enteredHour = ""
    @State private var showEdit = false
    
    var body: some View {
        VStack {
            if showEdit {
                TextField("Enter work start time", text: $enteredHour)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.showEdit = false
                }) {
                    Text("Confirm")
                }
            } else {
                Button(action: {
                    self.showEdit = true
                }) {
                    MenuDesign(text: workStartDisplay(enteredHour), icon: "exclamationmark.triangle", color: Color("red: 1.0, green: 0.6, blue: 0.6"))
                    
                        
                }
                
            }
        }
        .offset(y: -90)
        .frame(width: 100, height: 50)
    }
    
    func workStartDisplay(_ hour: String) -> String {
        let hours = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        let compliments = ["¡Ya casi!", "¿Ya sonreíste?", "¡Tú puedes!", "¡Hazlo un buen día!", "¡Trabaja duro!", "¡Falta poco!"]
        
        if let enteredHour = Int(hour), enteredHour >= 0, enteredHour <= 23 {
            let formattedHour = hours[enteredHour % 12]
            return "Terminas a las \(formattedHour) \(compliments.randomElement()!)"
        } else {
            return "¿A qué hora terminas?"
        }
    }
}

struct ComingSoonView: View {
    var body: some View {
        ZStack {
            Image("Fondo1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("Logo 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)

                Text("¡Pronto podrás utilizar esto!")
                    .font(.title)
                    .foregroundColor(.black)

                Text("Próximamente")
                    .foregroundColor(.black)
            }
            
        }
    }
}




