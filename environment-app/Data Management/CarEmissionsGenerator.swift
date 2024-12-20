import Foundation

class CarEmissionsCalculator {
    // Base emissions factors (kg CO2 per km)
    private let emissionsFactors: [Car: Double] = [
        .petrol: 0.192,      // Average petrol car emissions
        .diesel: 0.171,      // Average diesel car emissions
        .hybrid: 0.103,      // Average hybrid emissions
        .electric: 0.053,    // Based on average grid electricity emissions
        .nothing: 0.027      // Average public transport emissions per passenger
    ]
    
    // Adjustment factors
    private let urbanDrivingFactor = 1.2       // Urban driving typically increases emissions by 20%
    private let highwayDrivingFactor = 0.9     // Highway driving typically reduces emissions
    private let coldStartFactor = 1.1          // Cold starts increase emissions
    
    // Calculate emissions for a journey
    func calculateEmissions(carType: Car, distance: Float, isUrbanDriving: Bool = true) -> EmissionsResult {
        guard let baseFactor = emissionsFactors[carType] else {
            return EmissionsResult(
                totalEmissions: 0.0,
                description: "Invalid car type"
            )
        }
        
        // Apply driving condition factor
        let drivingFactor = isUrbanDriving ? urbanDrivingFactor : highwayDrivingFactor
        
        // Calculate total emissions
        let totalEmissions = Double(distance) * baseFactor * drivingFactor
        
        // Generate appropriate description
        let description: String
        switch carType {
        case .petrol:
            description = "Petrol vehicle emissions based on average fuel efficiency"
        case .diesel:
            description = "Diesel vehicle emissions based on average fuel efficiency"
        case .hybrid:
            description = "Hybrid vehicle emissions (combines electric and petrol power)"
        case .electric:
            description = "Electric vehicle emissions based on average grid carbon intensity"
        case .nothing:
            description = "Public transport emissions per passenger"
        }
        
        return EmissionsResult(
            totalEmissions: totalEmissions,
            description: description
        )
    }
    
    // Calculate monthly emissions from TravelData
    func calculateMonthlyEmissions(travelData: [TravelData], carType: Car) -> [Month: Double] {
        var monthlyEmissions: [Month: Double] = [:]
        
        for data in travelData {
            guard data.type == .car else { continue }
            
            let result = calculateEmissions(
                carType: carType,
                distance: data.distanceTravelled
            )
            
            monthlyEmissions[data.month, default: 0] += result.totalEmissions
        }
        
        return monthlyEmissions
    }
    
    // Get environmental impact rating (0-100)
    func getEnvironmentalImpactRating(carType: Car) -> Int {
        switch carType {
        case .nothing:
            return 90    // Public transport is most environmentally friendly
        case .electric:
            return 80    // Electric vehicles have low direct emissions
        case .hybrid:
            return 60    // Hybrids have moderate emissions
        case .diesel:
            return 40    // Diesel has higher particulate emissions
        case .petrol:
            return 30    // Standard petrol vehicles have highest emissions
        }
    }
}

struct EmissionsResult {
    let totalEmissions: Double      // kg CO2
    let description: String         // Description of calculation basis
}

// Example usage:
let carCalculator = CarEmissionsCalculator()

