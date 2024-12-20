import SwiftUI
import Charts

struct HousingChartView: View {
    @Binding var housingData: [HousingData]
    
    // Compute the max amount for y-axis scale
    private var maxAmount: Float {
        housingData.map(\.amount).max() ?? 0
    }
    
    // Group data by utility type and sort by month
    private var groupedData: [HouseDataType: [HousingData]] {
        let grouped = Dictionary(grouping: housingData, by: { $0.type })
        return grouped.mapValues { values in
            values.sorted { $0.month.rawValue < $1.month.rawValue }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Utility Footprint")
                .font(.custom("Josefin Sans", size: 16))
            
            if housingData.count != 0 {
                Chart {
                    ForEach(HouseDataType.allCases, id: \.self) { type in
                        if let typeData = groupedData[type] {
                            ForEach(typeData) { data in
                                LineMark(
                                    x: .value("Month", data.month.displayName),
                                    y: .value("Usage", data.amount)
                                )
                            }
                            .symbol(.circle)
                            .symbolSize(30)
                            .interpolationMethod(.linear)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(by: .value("", type.rawValue.capitalized))
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
                Text("Sorry but we don't seem to have recieved any utility data from you yet. Start by adding your utility logs through the section below. PS: You can swipe right to see your transportation data")
                    .font(.custom("Josefin Sans", size: 16))
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HousingChartView(housingData: .constant([
    ]))
}
