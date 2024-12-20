//
//  UtilityManagerView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI
import CustomAlert
import CustomToggle

struct GasUsageView: View {
    @Binding var userData: StorageData
    @State var gasUsage: Int = 0
    @State var confirm = false
    @Environment(\.dismiss) var dismiss
    @State var month: Month = .jan
    @State var gasWaterHeater: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                Text("Gas Usage")
                    .font(.custom("Crimson Pro", size: 36))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }
            HStack {
                Text("Track your gas usage here")
                    .font(.custom("Crimson Pro", size: 24))
                Spacer()
            }
            HStack {
                TextField("Enter Gas Usage Here", value: $gasUsage, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
                Text("m³")
                    .font(.custom("Josefin Sans", size: 16))
            }
            
            HStack {
                Text("Do you have a gas water heater?")
                    .font(.custom("Josefin Sans", size: 16))
                Spacer()
                BounceToggle(status: $gasWaterHeater, colorClose: .red, colorOpen: .green, thumbColor: .white,enableLine: false)
                    .scaleEffect(0.6)
            }
            
            HStack {
                Text("What month is this for? ")
                    .font(.custom("Josefin Sans", size: 16))
                Picker("Select a Month", selection: $month) {
                    ForEach(Month.allCases, id: \.self) { month in
                        Text(month.displayName)
                            .font(.custom("Josefin Sans", size: 16))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
            }
            
            Button {
                confirm = true
            } label: {
                Image(systemName: "checkmark")
                Text("Save")
                    .font(.custom("Josefin Sans", size: 16))
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .customAlert(isPresented: $confirm) {
            VStack {
                HStack {
                    Text("Are you sure?")
                        .font(.custom("Crimson Pro", size: 36))
                    Spacer()
                }
                
                HStack {
                    Text("You have used \(gasUsage)m³ in the month of \(month.displayName). You may loose credits if you have used too much.")
                        .font(.custom("Josefin Sans", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
        } actions: {
            Button {
                if gasUsage <= 6 && !gasWaterHeater {
                    userData.credits = userData.credits + 10
                } else if gasUsage <= 16 && gasWaterHeater {
                    userData.credits = userData.credits + 10
                } else {
                    userData.credits = userData.credits - 10
                }
                userData.housingData.append(HousingData(month: month, amount: Float(gasUsage), type: .gas))
                trimOldHousingData(userData: &userData)

                dismiss()
            } label: {
                Text("Yes, I am sure about this")
                    .font(.custom("Josefin Sans", size: 14))
            }
            
            Button(role: .cancel) {  } label: { Text("No wait, I think I entered it wrongly!").font(.custom("Josefin Sans", size: 14)).foregroundStyle(.red) }
        }
    }
}

#Preview {
    GasUsageView(userData: .constant(StorageData(name: "Advait",
                                                 username: "contyadvait",
                                                 carType: .hybrid)))
}
