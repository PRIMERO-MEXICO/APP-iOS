import SwiftUI
import Combine
import MapKit
struct Busqueda: View {
    
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
    @State var uid: String
    @State var user: String
    @State var isLogin: Bool
    @State var tmpMKMapItem: MKMapItem
    @State var tmpMKMapItem2: MKMapItem
    @State var seleccionar: Bool = false
    
    var body: some View {
        if seleccionar {
            if String(tmpMKMapItem.name!) != "Unknown Location",
               String(tmpMKMapItem2.name!) == "Unknown Location" {
                Navegacion2(uid: self.uid,
                            user: self.user,
                            isLogin: self.isLogin,
                            tmpMKMapItem: self.tmpMKMapItem,
                            tmpMKMapItem2: vm.placeTemporary)
            }
            else if String(tmpMKMapItem.name!) == "Unknown Location",
                      String(tmpMKMapItem2.name!) != "Unknown Location" {
                       Navegacion2(uid: self.uid,
                                   user: self.user,
                                   isLogin: self.isLogin,
                                   tmpMKMapItem: vm.placeTemporary,
                                   tmpMKMapItem2: self.tmpMKMapItem2)
                   }
            else if String(tmpMKMapItem.name!) == "Unknown Location",
                    String(tmpMKMapItem2.name!) == "Unknown Location" {
                Navegacion2(uid: self.uid,
                            user: self.user,
                            isLogin: self.isLogin,
                            tmpMKMapItem: vm.placeTemporary,
                            tmpMKMapItem2: self.tmpMKMapItem2)
            }
        } else {
            VStack {
                NavigationView {
                    VStack {
                        
                        List(vm.places) { place in
                            Text(place.name)
                        }
                    }
                    .searchable(text: $vm.searchText)
                    .navigationTitle("Places")
                }
                
                Button(action: {
                    self.seleccionar.toggle()
                }){
                    Text("Seleccionar")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 30)
                }
                .frame(width: 250, height: 40, alignment: .center)
                .background(Color.blue.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
                .padding(.top, 20)
            }
        }
    }
}
