import SwiftUI
import Combine

struct Busqueda: View {
    
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
    @State var uid: String
    @State var user: String
    @State var isLogin: Bool
    @State var seleccionar: Bool = false
    
    var body: some View {
        if seleccionar {
            Navegacion2(uid: self.uid, user: self.user, isLogin: self.isLogin, tmpMKMapItem: vm.placeTemporary)
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

struct Busqueda_Previews: PreviewProvider {
    static var previews: some View {
        let uid = "wFN8MaVR6BYt0CbFRVg4161agLJ2"
        let u: String = "nombre"
        let l: Bool = true
        
        Busqueda(uid: uid, user: u, isLogin: l)
    }
}
