//
//  UtilityManagerView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI
import CustomAlert
import CustomToggle
import AnimatedToggle

struct ElectricalUsageView: View {
    @Binding var userData: StorageData
    @State var electricalUsage: Int = 0
    @State var confirm = false
    @Environment(\.dismiss) var dismiss
    @State var month: Month = .jan
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                Text("Electrical Usage")
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
                Text("Track your electrical usage here")
                    .font(.custom("Crimson Pro", size: 24))
                Spacer()
            }
            HStack {
                TextField("Enter Electrical Usage Here", value: $electricalUsage, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
                Text("kWh")
                    .font(.custom("Josefin Sans", size: 16))
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
                    Text("You have used \(electricalUsage)kWh in the month of \(month.displayName). You may loose credits if you have used too much.")
                        .font(.custom("Josefin Sans", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
        } actions: {
            Button {
                if electricalUsage <= 450 {
                    userData.credits = userData.credits + 10
                } else {
                    userData.credits = userData.credits - 10
                }
                userData.housingData.append(HousingData(month: month, amount: Float(electricalUsage), type: .electrical))
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
    ElectricalUsageView(userData: .constant(StorageData(name: "Advait",
                                                 username: "contyadvait",
                                                 carType: .hybrid)))
}
