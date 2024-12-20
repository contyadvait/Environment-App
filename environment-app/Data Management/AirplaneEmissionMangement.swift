import Foundation

struct Airport {
    let code: String
    let name: String
    let coordinates: (latitude: Double, longitude: Double)
}

class FlightEmissionsCalculator {
    // Aircraft emissions data structure
    private struct AircraftEmissions {
        let model: String
        let kgCO2PerKm: Double
        let engineCount: Int
    }
    
    // Aircraft database
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
    
    enum CalculationError: Error {
        case airportNotFound(String)
        case aircraftNotFound(String)
        case invalidDistance
        case invalidEngineCount
        case networkError(String)
        case invalidResponse
    }
    
    // Function to fetch airport data
    func fetchAirportData(iataCode: String) async throws -> Airport {
        // Using the AviationStack API (you'll need to sign up for a free API key)
        let apiKey = "985e56511ce01c2c7cc96eff7a362755"
        let urlString = "http://api.aviationstack.com/v1/airports?access_key=\(apiKey)&iata_code=\(iataCode)"
        
        guard let url = URL(string: urlString) else {
            throw CalculationError.networkError("Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw CalculationError.networkError("Invalid response")
        }
        
        struct AviationStackResponse: Codable {
            struct AirportData: Codable {
                let airport_name: String
                let latitude: String
                let longitude: String
            }
            let data: [AirportData]
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(AviationStackResponse.self, from: data)
        
        guard let airportData = result.data.first else {
            throw CalculationError.airportNotFound(iataCode)
        }
        
        return Airport(
            code: iataCode,
            name: airportData.airport_name,
            coordinates: (
                latitude: Double(airportData.latitude) ?? 0,
                longitude: Double(airportData.longitude) ?? 0
            )
        )
    }
    
    // Calculate emissions with online airport data
    func calculateEmissions(from departure: String,
                          to arrival: String,
                          aircraftModel: String? = nil,
                          engineCount: Int? = nil) async throws -> Double {
        // Convert to uppercase
        let depCode = departure.uppercased()
        let arrCode = arrival.uppercased()
        
        // Fetch airport data
        let departureAirport = try await fetchAirportData(iataCode: depCode)
        let arrivalAirport = try await fetchAirportData(iataCode: arrCode)
        
        // Calculate distance
        let distance = calculateDistance(
            from: departureAirport.coordinates,
            to: arrivalAirport.coordinates
        )
        
        guard distance > 0 else {
            throw CalculationError.invalidDistance
        }
        
        // Get emissions rate
        let emissionsRate: Double
        
        if let model = aircraftModel {
            guard let aircraft = aircraftData.first(where: { $0.model == model }) else {
                throw CalculationError.aircraftNotFound(model)
            }
            emissionsRate = aircraft.kgCO2PerKm
        } else if let engines = engineCount {
            guard engines > 0 && engines <= 4 else {
                throw CalculationError.invalidEngineCount
            }
            
            let matchingAircraft = aircraftData.filter { $0.engineCount == engines }
            guard !matchingAircraft.isEmpty else {
                throw CalculationError.invalidEngineCount
            }
            
            emissionsRate = matchingAircraft.map { $0.kgCO2PerKm }.reduce(0, +) / Double(matchingAircraft.count)
        } else {
            // Default to average twin-engine emissions
            let twinEngineAircraft = aircraftData.filter { $0.engineCount == 2 }
            emissionsRate = twinEngineAircraft.map { $0.kgCO2PerKm }.reduce(0, +) / Double(twinEngineAircraft.count)
        }
        
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

let calculator = FlightEmissionsCalculator()

// Example usage with async/await:
func calculateFlightEmissions() async {
    let calculator = FlightEmissionsCalculator()
    
    do {
        let emissions = try await calculator.calculateEmissions(
            from: "LHR",
            to: "JFK",
            aircraftModel: "B777"
        )
        print("Estimated CO2 emissions: \(Int(emissions)) kg")
    } catch FlightEmissionsCalculator.CalculationError.airportNotFound(let code) {
        print("Airport not found: \(code)")
    } catch FlightEmissionsCalculator.CalculationError.networkError(let message) {
        print("Network error: \(message)")
    } catch {
        print("An error occurred: \(error)")
    }
}
