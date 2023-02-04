//
//  Main.swift
//  PrimeroMexico
//
//  Created by Fernando Arana on 29/01/23.
//

import SwiftUI

// View para Main
struct Main: View {
    var body: some View {
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
                        Rectangle()
                            .frame(width: 60, height: 20)
                            .cornerRadius(50)
                            .foregroundColor(.black)
                            .opacity(0.245)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 80)
                Spacer()
            }
            
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
