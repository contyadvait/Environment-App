//
//  PublicTransportView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI

struct PublicTransportView: View {
    @Binding var userData: StorageData
    @Environment(\.dismiss) var dismiss
    @State var distanceTravelled: Int = 3
    @State var confirm = false
    @State var month = Month.jan
    
    var body: some View {
        VStack {
            HStack {
                Text("Public Transport Tracker")
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
                Text("Track travels in Public Transport here")
                    .font(.custom("Crimson Pro", size: 24))
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Text("How far did you approximately travel?")
                    .font(.custom("Josefin Sans", size: 16))
                Spacer()
            }
            HStack {
                TextField("distance", value: $distanceTravelled, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
                Text("km")
                    .font(.custom("Josefin Sans", size: 16))
                Spacer()
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
                    Text("You have travelled \(distanceTravelled) in \(month). You may loose credits if you have used too much.")
                        .font(.custom("Josefin Sans", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
        } actions: {
            Button {
                if carCalculator.calculateEmissions(carType: .nothing, distance: Float(distanceTravelled)).totalEmissions <= Double(6.33) {
                    userData.credits = userData.credits + 25
                } else {
                    userData.credits = userData.credits + 25
                }

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
    PublicTransportView(userData: .constant(StorageData(name: "Advait",
                                                        username: "contyadvait",
                                                        carType: .hybrid)))
}
