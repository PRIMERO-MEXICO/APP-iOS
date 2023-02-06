//
//  Splash.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 29/01/23.
//

import SwiftUI

// View para Splash Inicial
struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    // @ObservedObject var viewModel: NavegacionViewModel
    
    var body: some View {
        if isActive {
            
            AuthContentView()
            // CoreLocationView()
            // Main(user: "hola", isLogin: true)
        } else {
            ZStack {
                Fondo()
                VStack {
                        Image("LogoPM")
                            .resizable()
                            .frame(width: 245, height: 250)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        self.isActive.toggle()
                    }
                }
            }
        }
    }
}


struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        
        //let viewModel = NavegacionViewModel()
        
        //SplashScreenView(viewModel: viewModel)
        SplashScreenView()
    }
}
