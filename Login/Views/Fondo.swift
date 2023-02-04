//
//  Fondo.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 29/01/23.
//

import SwiftUI

// View para desplegar Fondo
struct Fondo: View {
    var body: some View {
        Image("FondoPM")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .opacity(1)
    }
}


struct Fondo_Previews: PreviewProvider {
    static var previews: some View {
        Fondo()
    }
}
