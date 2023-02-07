//
//  SearchResultsViewModel.swift
//  AutocompleteSearch
//
//

import Foundation
import MapKit
import Combine

@MainActor
class SearchResultsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var placeTemporary: MKMapItem = MKMapItem()
    
    init() {
        cancellable = $searchText.debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { value in
                if !value.isEmpty && value.count > 3 {
                    self.search(text: value, region: LocationManager.shared.region)
                } else {
                    self.places = []
                }
            }
    }
    
    @Published var places = [PlaceViewModel]()
    
    func search(text: String, region: MKCoordinateRegion) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.placeTemporary = response.mapItems.first!
            // print(self.placeTemporary)
            self.places = response.mapItems.map(PlaceViewModel.init)
        }
    }
}

struct PlaceViewModel: Identifiable {
    
    let id = UUID()
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
}
