import Foundation

func trimOldHousingData(userData: inout StorageData) {
    // Get the chronological order of months
    let monthOrder = Month.allCases
    
    // Loop through each type of `HouseDataType`
    for type in HouseDataType.allCases {
        // Filter data for the current type
        var filteredData = userData.housingData.filter { $0.type == type }
        
        // Sort by chronological month order
        filteredData.sort {
            monthOrder.firstIndex(of: $0.month)! < monthOrder.firstIndex(of: $1.month)!
        }
        
        // Keep only the last 6 months
        if filteredData.count > 6 {
            filteredData = Array(filteredData.suffix(6))
        }
        
        // Replace the old data for this type in `housingData`
        userData.housingData = userData.housingData.filter { $0.type != type } + filteredData
    }
}
