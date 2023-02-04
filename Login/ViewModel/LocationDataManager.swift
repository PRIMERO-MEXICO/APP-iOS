//
//  LocationDataManager.swift
//  Login
//
//  Created by Fernando Arana on 03/02/23.
///  References:
///  1. https://coledennis.medium.com/tutorial-connecting-core-location-to-a-swiftui-app-dc62563bd1de
///
///  2. delegate objects: In Swift, a delegate is a controller object with a defined interface that can be used to control or modify the behavior of another object.
/// The first step to create a custom delegate is to create a delegate protocol. A protocol is an interface, a set of variables and functions, that the custom delegate must implement.
///  https://www.advancedswift.com/how-to-create-a-custom-delegate-in-swift/#:~:text=In%20Swift%2C%20a%20delegate%20is,UIApplicaitonDelegate%20in%20an%20iOS%20app.
///
///  3. controller object: A controller object acts as a coordinator or as an intermediary between one or more view objects and one or more model objects.
/// https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/ControllerObject.html#:~:text=A%20controller%20object%20acts%20as,one%20or%20more%20model%20objects.
///
///  4. Override initializer: In Swift initializers are not inherited for subclasses by default. If you want to provide the same initializer for a subclass that the parent class already has, you have to use the override keyword
/// https://theswiftdev.com/swift-init-patterns/#:~:text=Override%20initializer,to%20use%20the%20override%20keyword.
///
///  5. instance method:  Instance methods are functions that belong to instances of a particular class, structure, or enumeration.
///  Instance methods are functions that belong to instances of a particular class, structure, or enumeration.


import Foundation
import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:
            authorizationStatus = .restricted
            break
        
        case .denied:
            authorizationStatus = .denied
            break
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    // delegate functions:
    // 1. instance method that will tell our delegate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
