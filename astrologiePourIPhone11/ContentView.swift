//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI
import Foundation

private func loadValue(
        selectedDate: Date,
        selectedDateTransit: Date,
        lat: (Double, Double),
        lng: (Double, Double),
        tz: (Int32, Int32)) -> Swe.Chart {
    let chartDefault: Swe.Chart = loadDefaultValue().0
    //
    let nLng = lng.0 // chartDefault.nLng
    let tLng = lng.1 // chartDefault.tLng
    let nLat = lat.0 // chartDefault.nLat
    let tLat = lat.1 //chartDefault.tLat
    let nTimeZone = tz.0 // chartDefault.nTimeZone
    let tTimeZone = tz.1 // chartDefault.tTimeZone
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    let nYear = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nYear
    let tYear = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tYear
    dateFormatter.dateFormat = "MM"
    let nMonth = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nMonth
    let tMonth = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tMonth
    dateFormatter.dateFormat = "dd"
    let nDay = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nDay
    let tDay = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tDay
    dateFormatter.dateFormat = "hh"
    let nHour = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nHour
    let tHour = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tHour
    dateFormatter.dateFormat = "mm"
    let nMin = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nMin
    let tMin = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tMin
    return Swe.Chart(
            nLat: nLat,
            nLng: nLng,
            nTimeZone: nTimeZone,
            nYear: nYear,
            nMonth: nMonth,
            nDay: nDay,
            nHour: nHour,
            nMin: nMin,
            tLat: tLat,
            tLng: tLng,
            tTimeZone: tTimeZone,
            tYear: tYear,
            tMonth: tMonth,
            tDay: tDay,
            tHour: tHour,
            tMin: tMin)
}

struct ContentView: View {
    @State var selected: Int
    @State var isActive: Bool = false
    @State var swChiron: Bool = true

    var body: some View {
        VStack {
            if self.isActive {
                ZStack {
                    Image("bgl")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                    VStack {
                        TabView(selection: $selected) {
                            AstrologieView(
                                    swTransit: false,
                                    swChiron: swChiron
                            ).tabItem {
                                VStack {
                                    Image(systemName: "eye")
                                    Text("Natal")
                                }
                            }.tag(0)
                            AstrologieView(
                                    swTransit: true,
                                    swChiron: swChiron
                            ).tabItem {
                                VStack {
                                    Image(systemName: "eye")
                                    Text("Natal et Transit")
                                }
                            }.tag(1)
                            BodieSelectView(swChiron: swChiron).tabItem {
                                VStack {
                                    Image(systemName: "c.circle.fill")
                                    Text("Sélection planètes")
                                }
                            }.tag(2)
                            VStack {
                                Text("Développé par bressani.dev (Stéphane Bressani)")
                                Text("Cette application est sous license GNU public license version 3.")
                                Text("Elle utilise la libraiaire swiss ephemeris developé par Dieter Koch and Alois Treindl en Dual license (GNU v2 ou supérieur ou commercial)")
                                Text("Cette application utilise aussi le package swift Zip en MIT par Roy Marmelstein")
                            }.tabItem {
                                VStack {
                                    Image(systemName: "info.circle")
                                    Text("À propos")
                                }
                            }.tag(3)
                        }.onAppear() {
                            UITabBar.appearance().barTintColor = UIColor(Color(hex: "aa9966"))
                            UITabBar.appearance().unselectedItemTintColor = .systemGray5
                        }.accentColor(.white)
                    }
                }
            } else {
                Image("splash")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            // 6.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // 7.
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct BodieSelectView: View {
    @State var swChiron: Bool = true
    @State var swCeres: Bool = true

    var body: some View {
        ZStack {
            Image("bgl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            VStack {
                Spacer()
                HStack {
                    Toggle(isOn: $swCeres) {
                        Text("Ceres")
                    }
                    Image("b15").padding()
                    Toggle(isOn: $swChiron) {
                        Text("Chrion")
                    }
                    Image("b15").padding()
                }
                Spacer()
            }.padding()
        }
    }
}

struct AstrologieView: View {
    @State var swTransit: Bool
    @State var swChiron: Bool
    var FONTSIZE = 15.0
    var chartDefault: Swe.Chart = loadDefaultValue().0
    @State var selectedDate: Date = loadDefaultValue().1
    @State var selectedDateTransit: Date = Date()
    @State var latNatal: Double = loadDefaultValue().0.nLat
    @State var lngNatal: Double = loadDefaultValue().0.nLng
    @State var latTransit: Double = loadDefaultValue().0.tLat
    @State var lngTransit: Double = loadDefaultValue().0.tLng
    @State var tzNatal: Int32 = loadDefaultValue().0.nTimeZone
    @State var tzTransit: Int32 = loadDefaultValue().0.tTimeZone
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        return formatter
    }()
    let formatterNoFloat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = false
        return formatter
    }()
    var body: some View {
        ZStack {
            Image("bgl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            ScrollView {
                VStack {
                    Spacer().frame(height: 45)
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 400, height: 84)
                                    .background(Color.orange).opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        VStack {
                            DatePicker(
                                    "Date de naissance",
                                    selection: $selectedDate,
                                    displayedComponents: [.date, .hourAndMinute])
                                    .font(.system(size: FONTSIZE, weight: .light, design: .default))
                            HStack {
                                Text("Lat")
                                TextField(
                                        "Latitude",
                                        value: $latNatal,
                                        formatter: formatter
                                ).textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("Lng")
                                TextField(
                                        "Longitude",
                                        value: $lngNatal,
                                        formatter: formatter
                                ).textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("Tz")
                                TextField(
                                        "Timezone",
                                        value: $tzNatal,
                                        formatter: formatterNoFloat
                                ).textFieldStyle(RoundedBorderTextFieldStyle())
                            }.font(.system(size: FONTSIZE, weight: .light, design: .default))
                            if swTransit {
                                DatePicker(
                                        "Transit",
                                        selection: $selectedDateTransit,
                                        displayedComponents: [.date, .hourAndMinute])
                                        .font(.system(size: FONTSIZE, weight: .light, design: .default))
                                HStack {
                                    Text("Lat")
                                    TextField(
                                            "Latitude",
                                            value: $latTransit,
                                            formatter: formatter
                                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                                    Text("Lng")
                                    TextField(
                                            "Longitude",
                                            value: $lngTransit,
                                            formatter: formatter
                                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                                    Text("Tz")
                                    TextField(
                                            "Timezone",
                                            value: $tzNatal,
                                            formatter: formatterNoFloat
                                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                                }.font(.system(size: FONTSIZE, weight: .light, design: .default))
                            }

                        }.padding()
                    }
                }
                let swe = Swe(
                        chart: loadValue(
                                selectedDate: selectedDate,
                                selectedDateTransit: selectedDateTransit,
                                lat: (latNatal, latTransit),
                                lng: (lngNatal, lngTransit),
                                tz: (tzNatal, tzTransit)))
                ZStack {
                    VStack {
                        Spacer()
                                .frame(width: 390, height: 390)
                                .background(RadialGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.white]),
                                        center: .center, startRadius: 60, endRadius: 200)).opacity(0.1)
                                .clipShape(Circle())
                    }
                    ChartView(
                            swTransit: swTransit,
                            swChiron: swChiron,
                            swe: swe)
                }
                ZStack {
                    VStack {
                        Spacer()
                                .frame(width: 390, height: 390)
                                .background(.orange).opacity(0.1)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    ArrayView(
                            swTransit: swTransit,
                            transitType: .NatalNatal,
                            swe: swe)
                }
                if swTransit {
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 390, height: 390)
                                    .background(.orange).opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        ArrayView(
                                swTransit: swTransit,
                                transitType: .NatalTransit,
                                swe: swe)
                    }
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 390, height: 390)
                                    .background(.orange).opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        ArrayView(
                                swTransit: swTransit,
                                transitType: .TransitTransit,
                                swe: swe)
                    }

                }
            }
        }
    }
}

extension TabView {
    func myTabViewStyle() -> some View {
        self.background(Image("bgl"))              // Replace 'BackgroundImage' with your image name
                // or   self.background(Image(systemName: "questionmark.square"))
                .frame(width: 200, height: 500, alignment: .top)   // Optional, but shows the background
                .opacity(0.5)                                      // Again optional, but shows the effect

        // etc, with other View modifiers, choose the ones you need
    }
}

private func loadDefaultValue() -> (Swe.Chart, Date, Date) {
    var decode: Swe.Chart = Swe.Chart.init(
            nLat: 46.12,
            nLng: 6.09,
            nTimeZone: 2,
            nYear: 1981,
            nMonth: 1,
            nDay: 1,
            nHour: 0,
            nMin: 0,
            tLat: 46.12,
            tLng: 6.09,
            tTimeZone: 2,
            tYear: 2022,
            tMonth: 1,
            tDay: 24,
            tHour: 12,
            tMin: 0)
    do {
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let jsonData = try! String(contentsOfFile: path!).data(using: .utf8)!
        decode = try JSONDecoder().decode(Swe.Chart.self, from: jsonData)
    } catch {
        print("Unable to open chart file")
    }
    var dateN = DateComponents()
    dateN.year = Int(decode.nYear)
    dateN.month = Int(decode.nMonth)
    dateN.day = Int(decode.nDay)
    dateN.hour = Int(decode.nHour)
    dateN.minute = Int(decode.nMin)
    let calandarNatal = Calendar(identifier: .gregorian).date(from: dateN)
    let dateNatal = calandarNatal.unsafelyUnwrapped

    var dateT = DateComponents()
    dateT.year = Int(decode.tYear)
    dateT.month = Int(decode.tMonth)
    dateT.day = Int(decode.tDay)
    dateT.hour = Int(decode.nHour)
    dateT.minute = Int(decode.nMin)
    let calandarTransit = Calendar(identifier: .gregorian).date(from: dateT)
    let dateTransit = calandarTransit.unsafelyUnwrapped

    return (decode, dateNatal, dateTransit)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selected: 0)
    }
}

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}