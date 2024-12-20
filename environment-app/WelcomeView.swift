//
//  WelcomeView.swift
//  environment-app
//
//  Created by Milind Contractor on 19/12/24.
//

import SwiftUI
import Foundation

struct WelcomeView: View {
    @Binding var userData: StorageData
    @Binding var setup: Bool
    @Namespace var namespace
    @State var name: String = ""
    @State var username: String = ""
    @State var page = 1
    @State var carType: Car = .petrol
    @State var showError = false
    @Environment(\.dismiss) var dismiss
    
    var one: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Welcome to LeafLogic!")
                    .font(.custom("Crimson Pro", size: 36))
                Spacer()
            }
            .matchedGeometryEffect(id: "title", in: namespace)
            
            Text("Thanks for downloading our app and support the environment. Before we start, let's get to know your name and details")
                .font(.custom("Josefin Sans", size: 16))
                .multilineTextAlignment(.leading)
            HStack {
                Text("Name:")
                    .font(.custom("Josefin Sans", size: 16))
                TextField("Advait", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
            }
            HStack {
                Text("Friendly Name:")
                    .font(.custom("Josefin Sans", size: 16))
                TextField("advaitconty", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("Josefin Sans", size: 16))
            }
            
            Button {
                withAnimation {
                    if name != "" || username != "" {
                        page = page + 1
                    } else {
                        showError = true
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Next")
                        .font(.custom("Josefin Sans", size: 16))
                }
            }
            .buttonStyle(.borderedProminent)
            .matchedGeometryEffect(id: "next", in: namespace)
        }
        .padding()
        .matchedGeometryEffect(id: "whole", in: namespace)
        .alert("Name is empty. Please enter a name.", isPresented: $showError) {
            Button("Ok", role: .cancel) { }
        }
    }
    
    var two: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Welcome to LeafLogic!")
                    .font(.custom("Crimson Pro", size: 36))
                Spacer()
            }
            .matchedGeometryEffect(id: "title", in: namespace)
            
            Text("Next up, let's get to know some basic things, like what kind of car do you normally drive.")
                .font(.custom("Josefin Sans", size: 16))
            HStack {
                Text("Car Type:")
                    .font(.custom("Josefin Sans", size: 16))
                Picker(selection: $carType, label: Text("Car Type:")) {
                    ForEach(Car.allCases, id: \.self) { type in
                        Text(type.displayName)
                            .font(.custom("Josefin Sans", size: 16))
                            .tag(type)
                    }
                }
                .pickerStyle(.palette)
            }
            .environment(\.font, .custom("Josefin Sans", size: 16))
            
            Group {
                if carType == .diesel {
                    Text("Wow! You save about 20% of the emissions of a normal petrol car just by using a diesel car!")
                } else if carType == .hybrid {
                    Text("Great! You save about 52% of the emissions of a normal petrol car just by using a hybrid car!")
                } else if carType == .electric {
                    Text("Amazing! You save about 80% of the emissions of a normal petrol car just by using an electric!")
                } else if carType == .nothing {
                    Text("Crazy! You save about a whopping 93% of the emissions of a normal petrol car just by using no car but public transport!")
                }
            }
            .font(.custom("Josefin Sans", size: 14))
            .transition(.opacity.combined(with: .scale))
            
            Button {
                userData = StorageData(name: name, username: username, carType: carType)
                setup = false
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Finish setup!")
                        .font(.custom("Josefin Sans", size: 16))
                }
            }
        }
        .padding()
        .matchedGeometryEffect(id: "whole", in: namespace)
    }

    
    var body: some View {
        VStack {
            if page == 1 {
                one
            } else if page == 2 {
                two
            }
        }
    }
}
