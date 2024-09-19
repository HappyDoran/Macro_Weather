//
//  ContentView.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var weatherManager: WeatherManager
    @EnvironmentObject private var locationManager: LocationManager
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
                    await loadWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                    
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
            Text(weatherManager.currentWeather.name)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white)
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherManager.currentWeather.weather[0].icon)@2x.png")) { image in
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
                Text(String(format: "%.0f°", weatherManager.currentWeather.main.temp - 273))
                    .font(.system(size: 72, weight: .regular))
                    .foregroundColor(.white)
            }
            Text(weatherManager.currentWeather.weather[0].main)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
            
            HStack(spacing: 5) {
                Text(String(format: "최고: %.0f°", weatherManager.currentWeather.main.tempMax - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                Text(String(format: "최저: %.0f°", weatherManager.currentWeather.main.tempMin - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
    }
    
    private var fiveDaysWeatherView: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar").foregroundColor(.white)
                    Text("5일간의 일기 예보").foregroundColor(.white)
                    Spacer()
                }
                Divider().foregroundColor(.white)
                Spacer()
                ForEach(weatherManager.fiveDaysWeather.list, id: \.dt) { list in
                    HStack(spacing: 0) {
                        
                        Text(stringDateFormat(list.dtTxt) ?? "").font(.system(size: 14, weight: .bold)).foregroundColor(.white).frame(width: 110)
                        
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
                        
                        HStack{
                            Text(String(format: "%.0f°", list.main.tempMin - 273)).font(.system(size: 17, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                            
                            Rectangle().frame(width: 100,height: 1).cornerRadius(3)
                            
                            Text(String(format: "%.0f°", list.main.tempMax - 273)).font(.system(size: 17, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }
            .padding(.all, 16)
        }
        .padding(.horizontal, 16)
    }
}


extension ContentView {
    private func loadWeather(lat: Double, lon: Double) async {
        do {
            weatherManager.currentWeather = try await weatherManager.getWeather(url: URL.getCurrentWeather(lat: lat, lon: lon))
            weatherManager.fiveDaysWeather = try await weatherManager.getWeather(url: URL.getFiveDaysWeather(lat: lat, lon: lon))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 가져온 String타입의 Date의 형태를 바꿔주는 메소드
    /// - Parameters:
    ///   - dateString: API Response를 통해 가져온 dtTxt
    private func stringDateFormat(_ dateString: String)-> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        //String -> Date
        //데이터 포맷이 맞지 않을 경우 nil 반환
        guard let date = inputFormatter.date(from: dateString) else { return nil }

        //Date -> String
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd(E) HH시"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        return outputFormatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherManager(currentWeather: CurrentWeatherModel.dummyCurrentData, fiveDaysWeather: FiveDaysWeatherModel.dummyFiveDaysData))
            .environmentObject(LocationManager())
    }
}
