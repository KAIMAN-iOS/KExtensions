//
//  File.swift
//
//
//  Created by GG on 15/02/2021.
//

import MapKit
import UIKit
import PromiseKit

public protocol Direction {
    var id: String { get }
    var startLocation: CLLocationCoordinate2D { get }
    var endLocation: CLLocationCoordinate2D { get }
}

public protocol Directions {
    var id: String { get }
    var directions: [Direction] { get }
}

public struct DirectionsAnswer {
    public var id: String
    public var directions: [String: MKRoute]
}

public class DirectionManager {
    public enum DirectionManagerError: Error {
        case noRouteFound
    }
    static let shared: DirectionManager = DirectionManager()
    private init() {}
    
    public func loadDirections(for directions: Directions, transportType: MKDirectionsTransportType = .automobile) -> Promise<DirectionsAnswer> {
        return Promise<DirectionsAnswer>.init { resolver in
            when(resolved: directions.directions.compactMap({ self.loadDirection(for: $0, transportType: transportType) }))
                .done { results in
                    var directionsResult: [String: MKRoute] = [:]
                    results.forEach { res in
                        switch res {
                        case .fulfilled(let data): directionsResult[data.0] = data.1
                        default: ()
                        }
                    }
                    guard directionsResult.count > 0 else {
                        resolver.reject(DirectionManagerError.noRouteFound)
                        return
                    }
                    resolver.fulfill(DirectionsAnswer(id: directions.id, directions: directionsResult))
                }
        }
    }
    
    func loadDirection(for direction: Direction, transportType: MKDirectionsTransportType = .automobile) -> Promise<(String, MKRoute)> {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: direction.startLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: direction.endLocation, addressDictionary: nil))
        request.transportType = transportType
        return Promise<(String, MKRoute)>.init { resolver in
            MKDirections(request: request)
                .calculate { response, error in
                    guard let route = response?.routes.first else {
                        resolver.reject(DirectionManagerError.noRouteFound)
                        return
                    }
                    resolver.fulfill((direction.id , route))
                    
                }
        }
    }
}
