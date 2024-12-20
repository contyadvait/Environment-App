//
//  AirTravelsView.swift
//  environment-app
//
//  Created by Milind Contractor on 20/12/24.
//

import SwiftUI
import CustomToggle

struct AirTravelsView: View {
    @State var departureAirport: String = ""
    @State var arrivalAirport: String = ""
    @State var advanced = false
    @Environment(\.colorScheme) var colorScheme
    @State var engines: Int = 2
    @State var manufacterer: String = "Boeing"
    @State var model: String = "B737 NG"
    @State var confirm = false
    @Binding var userData: StorageData

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Air Travels Tracker")
                    .font(.custom("Crimson Pro", size: 36))
                Spacer()
            }
            
            HStack {
                Text("Track how far you can go this year")
                    .font(.custom("Crimson Pro", size: 24))
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Text("Enter your departure airport (3 character code):")
                    .font(.custom("Josefin Sans", size: 16))
                TextField("SIN", text: $departureAirport)
                    .font(.custom("Josefin Sans", size: 16))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.alphabet)
            }
            HStack {
                Text("Enter your arrival airport (3 character code):")
                    .font(.custom("Josefin Sans", size: 16))
                TextField("KUL", text: $departureAirport)
                    .font(.custom("Josefin Sans", size: 16))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.alphabet)
            }
            HStack {
                Text("Advanced Mode")
                    .font(.custom("Josefin Sans", size: 16))
                Spacer()
                BounceToggle(status: $advanced, colorClose: .red, colorOpen: .green, thumbColor: .white,enableLine: false)
                    .scaleEffect(0.6)
            }
            if !advanced {
                HStack {
                    Text("How many engines did your plane have? \(engines)")
                        .font(.custom("Josefin Sans", size: 16))
                    Stepper(" ", value: $engines, in: 2...4)
                }
            } else {
                HStack {
                    Text("Select your plane manufacturer:")
                        .font(.custom("Josefin Sans", size: 16))
                    Spacer()
                    Picker("", selection: $manufacterer) {
                        Text("Airbus")
                            .tag("Airbus")
                            .font(.custom("Josefin Sans", size: 16))
                        Text("Boeing")
                            .tag("Boeing")
                            .font(.custom("Josefin Sans", size: 16))
                        Text("Others")
                            .tag("Others")
                            .font(.custom("Josefin Sans", size: 16))
                    }
                }
                
                HStack {
                    Text("Select the plane model:")
                        .font(.custom("Josefin Sans", size: 16))
                    Spacer()
                    Picker("", selection: $model) {
                        if manufacterer == "Airbus" {
                            ForEach(airbusModels, id: \.self) { model in
                                Text(model)
                                    .tag(model)
                            }
                        } else if manufacterer == "Boeing" {
                            ForEach(boeingModels, id: \.self) { model in
                                Text(model)
                                    .tag(model)
                            }
                        } else {
                            ForEach(others, id: \.self) { model in
                                Text(model)
                                    .tag(model)
                            }
                        }
                    }
                }
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
                    Text("You have travelled from \(departureAirport) to \(arrivalAirport) using a plane. If you travelled too far, you could loose credits!")
                        .font(.custom("Josefin Sans", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
        } actions: {
            Button {
                if advanced {
                    if calculator.calculateEmissions(from: departureAirport, to: arrivalAirport, aircraftModel: model)! >= 1150 {
                        userData.credits = userData.credits - 25
                    } else {
                        userData.credits = userData.credits + 25
                    }
                } else {
                    if calculator.calculateEmissions(from: departureAirport, to: arrivalAirport, engineCount: engines)! >= 1150 {
                        userData.credits = userData.credits - 25
                    } else {
                        userData.credits = userData.credits + 25
                    }
                }
            } label: {
                Text("Yes, I am sure about this")
                    .font(.custom("Josefin Sans", size: 14))
            }
            
            Button(role: .cancel) {  } label: { Text("No wait, I think I entered it wrongly!").font(.custom("Josefin Sans", size: 14)).foregroundStyle(.red) }
        }
    }
}
