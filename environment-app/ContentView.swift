import SwiftUI
import Forever
import Charts

struct ContentView: View {
    @Forever("userdata") var userData = StorageData(name: "Advait",
                                                    username: "contyadvait",
                                                    carType: .hybrid,
                                                    housingData: [HousingData(month: .jan, amount: 20, type: .electrical),
                                                                  HousingData(month: .jan, amount: 13.5, type: .water),
                                                                  HousingData(month: .jan, amount: 10, type: .gas),
                                                                  HousingData(month: .feb, amount: 19, type: .electrical),
                                                                  HousingData(month: .feb, amount: 12, type: .water),
                                                                  HousingData(month: .feb, amount: 9.8, type: .gas),
                                                                  HousingData(month: .mar, amount: 19, type: .electrical),
                                                                  HousingData(month: .mar, amount: 12, type: .water),
                                                                  HousingData(month: .mar, amount: 9.8, type: .gas),
                                                                  HousingData(month: .apr, amount: 19, type: .electrical),
                                                                  HousingData(month: .apr, amount: 12, type: .water),
                                                                  HousingData(month: .apr, amount: 9.8, type: .gas)])
    @AppStorage("setup") var setup = false
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius = 10.0
    @State var openTransport = false
    @State var openTransportReason: Transport = .airplane
    @State var openUtility = false
    @State var openUtilityReason: HouseDataType = .electrical
    
    func transportItemButton(transport: Transport, icon: String, text: String) -> some View {
        Button {
            openTransport = true
            openTransportReason = transport
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.custom("Josefin Sans", size: 20))
            }
            .padding(10)
            .frame(width: 120, height: 100)
            .background(colorScheme == .dark ? Color(red: 18/225, green: 18/225, blue: 18/225) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
    
    func housingItemButton(item: HouseDataType, icon: String, text: String) -> some View {
        Button {
            openUtility = true
            openUtilityReason = item
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.custom("Josefin Sans", size: 20))
            }
            .padding(10)
            .frame(width: 120, height: 100)
            .background(colorScheme == .dark ? Color(red: 18/225, green: 18/225, blue: 18/225) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Group {
                        HStack {
                            Text("Home")
                                .font(.custom("Crimson Pro", size: 36))
                            Spacer()
                            Image(systemName: "leaf.fill")
                            Text("\(userData.credits)")
                                .font(.custom("Righteous", size: 24))
                        }
                        
                        HStack {
                            Text("Welcome back, \(userData.username)!")
                                .font(.custom("Josefin Sans", size: 20))
                            Spacer()
                        }
                        .padding(.bottom)
                    }
                    
                    ScrollView {
                        Group {
                            HStack {
                                Text("Your Usage")
                                    .font(.custom("Crimson Pro", size: 24))
                                Spacer()
                            }
                            ChartView(housingData: $userData.housingData, transportationData: $userData.travelData)
                                .frame(minHeight: 350, idealHeight: 375, maxHeight: 400)
                        }
                        Group {
                            HStack {
                                Text("Tracking Carbon Usage")
                                    .font(.custom("Crimson Pro", size: 24))
                                Spacer()
                            }
                            // --------------------------------------
                            // Housing section
                            // --------------------------------------
                            VStack {
                                HStack {
                                    Text("Housing")
                                        .font(.custom("Josefin Sans", size: 20))
                                    Spacer()
                                }.padding(.top, 1)
                                ScrollView(.horizontal) {
                                    HStack {
                                        housingItemButton(item: .electrical, icon: "bolt", text: "Electrical Usage")
                                        housingItemButton(item: .gas, icon: "flame", text: "Gas\nUsage")
                                        VStack(spacing: 10) {
                                            Image(systemName: "flame")
                                            Text("Gas\nUsage")
                                                .multilineTextAlignment(.center)
                                                .font(.custom("Josefin Sans", size: 20))
                                        }
                                        .padding(10)
                                        .frame(width: 120, height: 100)
                                        .background(colorScheme == .dark ? Color(red: 18/225, green: 18/225, blue: 18/225) : Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                                        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        
                                        VStack(spacing: 10) {
                                            Image(systemName: "drop")
                                            Text("Water\nUsage")
                                                .multilineTextAlignment(.center)
                                                .font(.custom("Josefin Sans", size: 20))
                                        }
                                        .padding(10)
                                        .frame(width: 120, height: 100)
                                        .background(colorScheme == .dark ? Color(red: 18/225, green: 18/225, blue: 18/225) : Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                                        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    }
                                }
                            }
                            
                            // --------------------------------------
                            // Transport section
                            // --------------------------------------
                            VStack {
                                HStack {
                                    Text("Transport")
                                        .font(.custom("Josefin Sans", size: 20))
                                    Spacer()
                                }.padding(.top, 1)
                                ScrollView(.horizontal) {
                                    HStack {
                                        transportItemButton(transport: .airplane, icon: "globe.asia.australia", text: "Air\nTravels")
                                        
                                        transportItemButton(transport: .publicTransport, icon: "bus.fill", text: "Public\nTransport")
                                        
                                        transportItemButton(transport: .car, icon: "car", text: "Car")
                                    }
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .padding()
                .fullScreenCover(isPresented: $setup) { WelcomeView(userData: $userData, setup: $setup) }
            }
        }
    }
}

#Preview {
    ContentView()
}
