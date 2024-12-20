//
//  TransporationView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI

struct TransportationView: View {
    @Binding var userData: StorageData
    @Binding var transportOpenReason: Transport
    var body: some View {
        VStack {
            if transportOpenReason == .airplane {
                AirTravelsView(userData: $userData)
            } else if transportOpenReason == .car {
                CarTravelsView(userData: $userData)
            } else if transportOpenReason == .publicTransport {
                //            PublicTransportView(userData: $userData)
            }
        }
        .onAppear {
            print(transportOpenReason)
        }
    }
}
