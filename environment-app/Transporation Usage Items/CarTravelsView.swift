//
//  CarTravelsView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI
import CustomAlert
import CustomToggle

struct CarTravelsView: View {
    @Binding var userData: StorageData
    @State var car: Car = .petrol
    @State var month: Month = .jan
    @State var distanceTravelled: Double = 0
    @Environment(\.dismiss) var dismiss
    @State var confirm = false
    @State var urbanDriving = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Car Travels")
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
                Text("Track your car travel usage here")
                    .font(.custom("Crimson Pro", size: 24))
                Spacer()
            }
            HStack {
                TextField("Enter distance travelled in your car", value: $distanceTravelled, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
                Text("km")
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
            
            HStack {
                Text("What kind of car do you drive?")
                    .font(.custom("Josefin Sans", size: 16))
                Picker("Select a Month", selection: $car) {
                    ForEach(Car.allCases, id: \.self) { month in
                        Text(month.displayName)
                            .font(.custom("Josefin Sans", size: 16))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
            }
            
            HStack {
                Text("Did you drive this mainly in an urban environment?")
                    .font(.custom("Josefin Sans", size: 16))
                Spacer()
                BounceToggle(status: $urbanDriving, colorClose: .red, colorOpen: .green, thumbColor: .white,enableLine: false)
                    .scaleEffect(0.6)
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
                if carCalculator.calculateEmissions(carType: car, distance: Float(distanceTravelled), isUrbanDriving: urbanDriving).totalEmissions <= Double(6.33) {
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
