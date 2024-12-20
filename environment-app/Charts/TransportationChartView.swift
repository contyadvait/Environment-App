import SwiftUI
import Charts

struct TransportationChartView: View {
    @Binding var transportationData: [TravelData]
    
    // Compute the max amount for y-axis scale
    private var maxAmount: Float {
        transportationData.map(\.distanceTravelled).max() ?? 0
    }
    
    // Group data by utility type and sort by month
    private var groupedData: [Transport: [TravelData]] {
        let grouped = Dictionary(grouping: transportationData, by: { $0.type })
        return grouped.mapValues { values in
            values.sorted { $0.month.rawValue < $1.month.rawValue }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if transportationData.count != 0 {
                Text("Transportation Footprint")
                    .font(.custom("Josefin Sans", size: 16))
                
                Chart {
                    ForEach(Transport.allCases, id: \.self) { type in
                        if let typeData = groupedData[type] {
                            ForEach(typeData) { data in
                                LineMark(
                                    x: .value("Month", data.month.displayName),
                                    y: .value("Usage", data.distanceTravelled)
                                )
                            }
                            .symbol(.circle)
                            .symbolSize(30)
                            .interpolationMethod(.linear)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(by: .value("", type.displayName))
                        }
                    }
                }
                .frame(height: 300)
                .chartYScale(domain: 0...Double(maxAmount * 1.2))
                .chartXAxis {
                    AxisMarks(preset: .aligned)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartLegend(position: .automatic)
            } else {
                Text("Sorry but we don't seem to have recieved any transportation data from you yet. Start by adding your travel logs through the section below. PS: You can swipe left to see your utility data")
                    .font(.custom("Josefin Sans", size: 16))
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    TransportationChartView(transportationData: .constant([
        TravelData(month: .jan, distanceTravelled: 10, type: .publicTransport),
        TravelData(month: .jan, distanceTravelled: 9.3, type: .airplane),
        TravelData(month: .jan, distanceTravelled: 7, type: .car),
        TravelData(month: .feb, distanceTravelled: 80, type: .publicTransport),
        TravelData(month: .feb, distanceTravelled: 13, type: .airplane),
        TravelData(month: .feb, distanceTravelled: 9, type: .car)
    ]))
}
