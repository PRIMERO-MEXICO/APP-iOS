//
//  Splash.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 29/01/23.
//

import SwiftUI

// View para Splash Inicial
struct Splash: View {
    var body: some View {
        VStack {
            ZStack {
                Fondo()
                Image("LogoPM")
                    .resizable()
                    .frame(width: 245, height: 250)
            }
        }
    }
}


struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
