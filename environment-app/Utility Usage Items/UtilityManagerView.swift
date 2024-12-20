//
//  UtilityManagerView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI

struct UtilityManagerView: View {
    @Binding var userData: StorageData
    var utilityOpenReason: HouseDataType
    var body: some View {
        if utilityOpenReason == .gas {
            GasUsageView(userData: $userData)
        } else if utilityOpenReason == .water {
            WaterUsageView(userData: $userData)
        } else if utilityOpenReason == .electrical {
            ElectricalUsageView(userData: $userData)
        }
    }
}

#Preview {
    UtilityManagerView(userData: .constant(StorageData(name: "Advait",
                                                       username: "contyadvait",
                                                       carType: .hybrid)), utilityOpenReason: .gas)
}
