//
//  TransporationView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI

struct TransportationView: View {
    @Binding var userData: StorageData
    var transportOpenReason: Transport
    var body: some View {
        if transportOpenReason == .airplane {
            AirTravelsView(userData: $userData)
        } else if transportOpenReason == .car {
            CarTravelsView(userData: $userData)
        } else if transportOpenReason == .publicTransport {
//            PublicTransportView(userData: $userData)
        }
    }
}
