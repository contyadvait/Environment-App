//
//  AirplaneEmissionMangement.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//
import Foundation

// Aircraft emissions data structure
struct AircraftEmissions {
    let model: String
    let kgCO2PerKm: Double
    let engineCount: Int
}

class FlightEmissionsCalculator {
    // Database of aircraft emissions data
    private let aircraftData: [AircraftEmissions] = [
        // Airbus models
        AircraftEmissions(model: "A300", kgCO2PerKm: 20.5, engineCount: 2),
        AircraftEmissions(model: "A310", kgCO2PerKm: 17.8, engineCount: 2),
        AircraftEmissions(model: "A320ceo", kgCO2PerKm: 14.9, engineCount: 2),
        AircraftEmissions(model: "A320neo", kgCO2PerKm: 11.3, engineCount: 2),
        AircraftEmissions(model: "A330ceo", kgCO2PerKm: 26.2, engineCount: 2),
        AircraftEmissions(model: "A330neo", kgCO2PerKm: 22.1, engineCount: 2),
        AircraftEmissions(model: "A340", kgCO2PerKm: 32.8, engineCount: 4),
        AircraftEmissions(model: "A350", kgCO2PerKm: 24.6, engineCount: 2),
        AircraftEmissions(model: "A380", kgCO2PerKm: 48.4, engineCount: 4),
        
        // Boeing models
        AircraftEmissions(model: "B737", kgCO2PerKm: 15.6, engineCount: 2),
        AircraftEmissions(model: "B737 MAX", kgCO2PerKm: 12.1, engineCount: 2),
        AircraftEmissions(model: "B747-400", kgCO2PerKm: 43.2, engineCount: 4),
        AircraftEmissions(model: "B777", kgCO2PerKm: 31.5, engineCount: 2),
        AircraftEmissions(model: "B787", kgCO2PerKm: 23.9, engineCount: 2),
        
        // Regional aircraft
        AircraftEmissions(model: "CRJ series", kgCO2PerKm: 9.8, engineCount: 2),
        AircraftEmissions(model: "ATR series", kgCO2PerKm: 5.2, engineCount: 2),
        AircraftEmissions(model: "ERJ series", kgCO2PerKm: 8.9, engineCount: 2)
    ]
    
    // Airport coordinates database (sample)
    private let airportCoordinates: [String: (latitude: Double, longitude: Double)] = [
        "LAX": (33.9425, -118.4081),
        "JFK": (40.6413, -73.7781),
        "LHR": (51.4700, -0.4543),
        "SYD": (-33.9399, 151.1753),
        "DXB": (25.2532, 55.3657),
        // Add more airports as needed
    ]
    
    // Calculate emissions for a flight
    func calculateEmissions(from departure: String, to arrival: String, aircraftModel: String? = nil, engineCount: Int? = nil) -> Double? {
        // Get coordinates
        guard let departureCoords = airportCoordinates[departure],
              let arrivalCoords = airportCoordinates[arrival] else {
            print("Airport not found in database")
            return nil
        }
        
        // Calculate distance
        let distance = calculateDistance(
            from: departureCoords,
            to: arrivalCoords
        )
        
        // Get emissions rate
        let emissionsRate: Double
        
        if let model = aircraftModel {
            // Use specific aircraft model if provided
            guard let aircraft = aircraftData.first(where: { $0.model == model }) else {
                print("Aircraft model not found")
                return nil
            }
            emissionsRate = aircraft.kgCO2PerKm
        } else if let engines = engineCount {
            // Estimate based on engine count if model not provided
            let averageEmissionsForEngineCount = aircraftData
                .filter { $0.engineCount == engines }
                .map { $0.kgCO2PerKm }
                .reduce(0.0, +) / Double(aircraftData.filter { $0.engineCount == engines }.count)
            emissionsRate = averageEmissionsForEngineCount
        } else {
            print("Either aircraft model or engine count must be provided")
            return nil
        }
        
        // Calculate total emissions
        return distance * emissionsRate
    }
    
    // Calculate distance between two coordinates using Haversine formula
    private func calculateDistance(from: (latitude: Double, longitude: Double),
                                 to: (latitude: Double, longitude: Double)) -> Double {
        let R = 6371.0 // Earth's radius in kilometers
        
        let lat1 = from.latitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let deltaLat = (to.latitude - from.latitude) * .pi / 180
        let deltaLon = (to.longitude - from.longitude) * .pi / 180
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) +
                cos(lat1) * cos(lat2) *
                sin(deltaLon/2) * sin(deltaLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return R * c
    }
}

// Example usage:
let calculator = FlightEmissionsCalculator()
