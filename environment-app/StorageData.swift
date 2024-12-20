//
//  StorageData.swift
//  environment-app
//
//  Created by Milind Contractor on 19/12/24.
//

import Foundation
import SwiftUI

enum Car: String, CaseIterable, Codable {
    case petrol
    case diesel
    case hybrid
    case electric
    case nothing

    var displayName: String {
        switch self {
        case .petrol: return "Petrol"
        case .diesel: return "Diesel"
        case .hybrid: return "Hybrid"
        case .electric: return "Electric"
        case .nothing: return "Public Transport"
        }
    }
}

enum Transport: String, CaseIterable, Codable {
    case airplane
    case car
    case publicTransport

    var displayName: String {
        switch self {
        case .airplane:
            return "Aeroplane"
        case .car:
            return "Car"
        case .publicTransport:
            return "Public Transport"
        }
    }
}

enum Month: String, CaseIterable, Codable {
    case jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    
    var displayName: String {
        switch self {
        case .jan:
            return "Jan"
        case .feb:
            return "Feb"
        case .mar:
            return "Mar"
        case .apr:
            return "Apr"
        case .may:
            return "May"
        case .jun:
            return "Jun"
        case .jul:
            return "Jul"
        case .aug:
            return "Aug"
        case .sep:
            return "Sep"
        case .oct:
            return "Oct"
        case .nov:
            return "Nov"
        case .dec:
            return "Dec"
        }
    }
}

enum HouseDataType: String, CaseIterable, Codable  {
    case electrical, water, gas
    var color: Color {
        switch self {
        case .electrical:
            return Color.yellow
        case .water:
            return Color.blue
        case .gas:
            return Color.purple
        }
    }
}

struct HousingData: Codable, Identifiable {
    var id = UUID()
    
    var month: Month
    var amount: Float
    var type: HouseDataType
}

struct TravelData: Codable, Identifiable {
    var id = UUID()
    
    var month: Month
    var distanceTravelled: Float
    var type: Transport
}

struct StorageData: Codable, Identifiable {
    let id = UUID()
    
    var name: String
    var username: String
    var carType: Car
    var credits: Int = 100
    
    var housingData: [HousingData] = []
    var travelData: [TravelData] = []
}
