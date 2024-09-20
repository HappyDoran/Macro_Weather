//
//  ContentView.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var network: Network
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var currentWeather: CurrentWeatherModel = CurrentWeatherModel.dummyCurrentData
    @State private var fiveDaysWeather: FiveDaysWeatherModel = FiveDaysWeatherModel.dummyFiveDaysData
    
    @State private var isLoading = true
    @State private var isImageLoaded = false
    @State private var showingAlert = false
    
    @State private var lat: Double = 0.0
    @State private var lon: Double = 0.0
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image("Background").resizable().ignoresSafeArea(.all)
            
            if isLoading {
                ProgressView("데이터를 불러오는 중...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .font(.headline)
            } else {
                ScrollView {
                    plusView
                    currentWeatherView.padding(.top, 50)
                    fiveDaysWeatherView
                }
                .refreshable {
                    if let currentLocation = locationManager.currentLocation {
                        await loadWeather(lat: currentLocation.latitude,lon: currentLocation.longitude)
                    }
                }
            }
        }
        .onAppear {
            locationManager.checkLocationAuthorization()
            if let currentLocation = locationManager.currentLocation {
                Task {
                    await loadWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                    
                    self.lat = currentLocation.latitude
                    self.lon = currentLocation.longitude
                    
                    isLoading = false
                }
            }
        }
    }
}

extension ContentView {
    private var plusView: some View {
        HStack {
            Spacer()
            Button(action: {
                showingAlert.toggle()
            }){
                Image(systemName: "plus").resizable().frame(width: 20,height: 20).foregroundColor(.white)
            }
            .alert("위치 변경", isPresented: $showingAlert) {
                TextField("위도값을 입력해주세요", value: $lat, formatter: positionFormatter).focused($isFocused).keyboardType(.decimalPad)
                TextField("경도값을 입력해주세요", value: $lon, formatter: positionFormatter).focused($isFocused).keyboardType(.decimalPad)
                Button("변경", action: {
                    isLoading = true
                    Task {
                        await loadWeather(lat: lat, lon: lon)
                        isLoading = false
                    }
                })
                Button("현재 위치로 재설정", action: {
                    if let currentLocation = locationManager.currentLocation {
                        isLoading = true
                        Task {
                            await loadWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                            lat = currentLocation.latitude
                            lon = currentLocation.longitude
                            isLoading = false
                        }
                    }
                })
                Button("취소", role: .cancel) { }
            } message: {
                Text("변경할 좌표를 입력해주세요.")
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var currentWeatherView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("나의 위치").font(.title).foregroundColor(.white)
            Text(currentWeather.name)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white)
            HStack(spacing: 0) {
                
                CacheAsyncImage(
                    url: URL(string: "https://openweathermap.org/img/wn/\(currentWeather.weather[0].icon)@2x.png")!,
                    placeholder: {
                        ProgressView().frame(width: 100, height: 100)
                    },
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                )
                
                Text(String(format: "%.0f°", currentWeather.main.temp - 273))
                    .font(.system(size: 72, weight: .regular))
                    .foregroundColor(.white)
            }
            Text(currentWeather.weather[0].main)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
            
            HStack(spacing: 5) {
                Text(String(format: "최고: %.0f°", currentWeather.main.tempMax - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                Text(String(format: "최저: %.0f°", currentWeather.main.tempMin - 273))
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
    }
    
    private var fiveDaysWeatherView: some View {
        ZStack {
            Rectangle().background(.ultraThinMaterial).cornerRadius(10)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar").foregroundColor(.white)
                    Text("5일간의 일기 예보").foregroundColor(.white)
                    Spacer()
                }
                Divider().foregroundColor(.white)
                Spacer()
                ForEach(fiveDaysWeather.list, id: \.dt) { list in
                    HStack(spacing: 0) {
                        Text(stringDateFormat(list.dtTxt) ?? "").font(.system(size: 14, weight: .bold)).foregroundColor(.white).frame(width: 110)
                        
                        CacheAsyncImage(
                            url: URL(string: "https://openweathermap.org/img/wn/\(list.weather[0].icon)@2x.png")!,
                            placeholder: {
                                ProgressView().frame(width: 32, height: 32)
                            },
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        )
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
            self.currentWeather = try await network.fetchData(url: URL.getCurrentWeather(lat: lat, lon: lon))
            self.fiveDaysWeather = try await network.fetchData(url: URL.getFiveDaysWeather(lat: lat, lon: lon))
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
    
    private var positionFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 10
        
        return formatter
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
            .environmentObject(LocationManager())
    }
}
