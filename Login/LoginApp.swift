//
//  LoginApp.swift
//  Login
//
//  Created by Isai Ambrocio on 26/01/23.
//

import SwiftUI
import MapKit

@main
struct LoginApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // Inicializamos la clase NavegacionViewModel como un apuntador.
    // let viewModel = NavegacionViewModel()
    
    let uid = "wFN8MaVR6BYt0CbFRVg4161agLJ2"
    let u: String = "nombre"
    let l: Bool = true
    let tmp1 = MKMapItem()
    let tmp2 = MKMapItem()
    
    var body: some Scene {
        WindowGroup {
            // AuthContentView()
            Navegacion2(uid: self.uid,
                        user: self.u,
                        isLogin: self.l,
                        tmpMKMapItem: tmp1,
                        tmpMKMapItem2: tmp2)
        }
    }
}
