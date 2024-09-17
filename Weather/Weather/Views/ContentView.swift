//
//  ContentView.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var currentWeather: CurrentWeather
    @EnvironmentObject private var fiveDaysWeather: FiveDaysWeather
    @StateObject private var locationManager = LocationManager()
    
    @State private var isLoading = true
    @State private var isImageLoaded = false
    
    var body: some View {
        ZStack {
            Image("Background").resizable().ignoresSafeArea(.all)
            
            if isLoading {
                ProgressView("데이터를 불러오는 중...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .font(.headline)
            } else {
                ScrollView {
                    currentWeatherView.padding(.top, 50)
                    fiveDaysWeatherView
                }
            }
        }
        .onAppear {
            locationManager.checkLocationAuthorization()
            if let currentLocation = locationManager.currentLocation {
                Task {
                    await loadCurrentWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                    await loadFiveDaysWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)

                    isLoading = false
                }
            }
        }
    }
}

extension ContentView {
    private var currentWeatherView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("나의 위치").font(.title).foregroundColor(.white)
            Text(currentWeather.weather.name)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white)
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(currentWeather.weather.weather[0].icon)@2x.png")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .onAppear {
                            isImageLoaded = true
                        }
                } placeholder: {
                    ProgressView().frame(width: 100, height: 100)
                }
                .onAppear {
                    if !isImageLoaded {
                        isLoading = false
                    }
                }
                Text(String(format: "%.0f°", currentWeather.weather.main.temp - 273))
                    .font(.system(size: 72, weight: .regular))
                    .foregroundColor(.white)
            }
            Text(currentWeather.weather.weather[0].main)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
            
            HStack(spacing: 5) {
                Text(String(format: "최고: %.0f°", currentWeather.weather.main.tempMax - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                Text(String(format: "최저: %.0f°", currentWeather.weather.main.tempMin - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
    }
    
    private var fiveDaysWeatherView: some View {
        ZStack {
//            Rectangle()
//                .frame(height: 290)
//                .background(.ultraThinMaterial)
//                .cornerRadius(10)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar").foregroundColor(.white)
                    Text("5일간의 일기 예보").foregroundColor(.white)
                    Spacer()
                }
                Divider().foregroundColor(.white)
                Spacer()
                ForEach(fiveDaysWeather.weather.list, id: \.dt) { list in
                    HStack{
                        Text(list.dtTxt).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(list.weather[0].icon)@2x.png"))
                        { image in
                           image
                               .resizable()
                               .scaledToFit()
                               .frame(width: 32, height: 32)
                               .onAppear {
                                   isImageLoaded = true
                               }
                       } placeholder: {
                           ProgressView().frame(width: 32, height: 32)
                       }
                        Spacer()
                        Text(String(format: "%.0f°", list.main.tempMin - 273)).font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                        Rectangle().frame(width: 100,height: 1).cornerRadius(3)
                        Text(String(format: "%.0f°", list.main.tempMax - 273)).font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .padding(.all, 16)
        }
        .padding(.horizontal, 16)
    }
}


extension ContentView {
    private func loadCurrentWeather(lat: Double, lon: Double) async {
        do {
            try await currentWeather.getCurrentWeather(lat: lat, lon: lon)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFiveDaysWeather(lat: Double, lon: Double) async {
        do {
            try await fiveDaysWeather.getFiveDaysWeather(lat: lat, lon: lon)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CurrentWeather())
            .environmentObject(FiveDaysWeather())
    }
}
