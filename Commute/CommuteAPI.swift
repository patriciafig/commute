//
//  CommuteAPI.swift
//  Commute
//
//  Created by Patricia on 5/4/18.
//  Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import Alamofire

final class CommuteAPI {
    
    struct TripUpdateEntity: Decodable {
        let entity: [BusStop]
    }
    
    struct VehiclePositionEntity: Decodable {
        let entity: [VehiclePosition]
    }
    
    struct VehiclePosition: Decodable {
        let id: String
        let vehicle: Vehicle
        
        struct Vehicle: Decodable {
            let position: Position
            let timestamp: String
            let vehicle: VehicleInfo
            
            struct Position: Decodable {
                let bearing: Double
                let latitude: Double
                let longitude: Double
            }
        }
    }
    
    struct VehicleInfo: Decodable {
        let id: String
        let label: String
    }
    
    struct BusStop: Decodable {
        let id: String
        let tripUpdate: TripUpdate
    }
    
    struct TripUpdate: Decodable {
        let stopTimeUpdate: [StopTimeUpdate]
        let trip: Trip
        let vehicle: VehicleInfo
        
        struct StopTimeUpdate: Decodable {
            let arrival: Arrival
            let departure: Departure
            let scheduleRelationship: String
            let stopId: String
            let stopSequence: Int
            
            struct Arrival: Decodable {
                let time: String
            }
            
            struct Departure: Decodable {
                let time: String
            }
        }
        
        struct Trip: Decodable {
            let directionId: Int
            let routeId: Int
            let scheduleRelationship: String
            let tripId: String
        }
    }
    
    static func tripUpdates(_ completion: @escaping ([BusStop]) -> ()) {
        let endpoint = K_WEB_SERVICE_URL + K_PATH_TRIP
        
        Alamofire.request(endpoint, method: .get).responseJSON {
            if let data = $0.data {
                let tripUpdates = try! JSONDecoder().decode(TripUpdateEntity.self, from: data)
                completion(tripUpdates.entity)
            } else {
                completion([])
            }
        }
    }
    
    static func vehiclePosition(_ completion: @escaping ([VehiclePosition]) -> ()) {
        let endpoint = K_WEB_SERVICE_URL + K_PATH_VEHICLE
        
        Alamofire.request(endpoint, method: .get).responseJSON {
            if let data = $0.data {
                let vehiclePositions = try! JSONDecoder().decode(VehiclePositionEntity.self, from: data)
                completion(vehiclePositions.entity)
            } else {
                completion([])
            }
        }
    }
}
