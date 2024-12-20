//
//  Charts.swift
//  environment-app
//
//  Created by Milind Contractor on 19/12/24.
//

import SwiftUI

struct ChartView: View {
    @Binding var housingData: [HousingData]
    @Binding var transportationData: [TravelData]
    
    var body: some View {
        TabView {
            Tab("Home Utilities", systemImage: "house") {
                HousingChartView(housingData: $housingData)
            }


            Tab("Transportation", systemImage: "bus.doubledecker") {
                TransportationChartView(transportationData: $transportationData)
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ChartView(housingData: .constant([
        HousingData(month: .jan, amount: 20, type: .electrical),
        HousingData(month: .jan, amount: 13.5, type: .water),
        HousingData(month: .jan, amount: 10, type: .gas),
        HousingData(month: .feb, amount: 19, type: .electrical),
        HousingData(month: .feb, amount: 12, type: .water),
        HousingData(month: .feb, amount: 9.8, type: .gas),
        HousingData(month: .mar, amount: 19, type: .electrical),
        HousingData(month: .mar, amount: 12, type: .water),
        HousingData(month: .mar, amount: 9.8, type: .gas),
        HousingData(month: .apr, amount: 19, type: .electrical),
        HousingData(month: .apr, amount: 12, type: .water),
        HousingData(month: .apr, amount: 9.8, type: .gas)
    ]), transportationData: .constant([
        TravelData(month: .jan, distanceTravelled: 10, type: .publicTransport),
        TravelData(month: .jan, distanceTravelled: 9.3, type: .airplane),
        TravelData(month: .jan, distanceTravelled: 7, type: .car),
        TravelData(month: .feb, distanceTravelled: 80, type: .publicTransport),
        TravelData(month: .feb, distanceTravelled: 13, type: .airplane),
        TravelData(month: .feb, distanceTravelled: 9, type: .car)
    ]))
}
