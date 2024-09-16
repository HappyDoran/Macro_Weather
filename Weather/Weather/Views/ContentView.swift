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
    
    var body: some View {
            ZStack{
                Image("Background").resizable().ignoresSafeArea(.all)
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Text("나의 위치").font(.title)
                        Text("서울특별시").font(.system(size: 14, weight: .light))
                        Text("33°").font(.system(size: 72, weight: .regular)).padding(.leading, 30)
                        Text("대체로 흐림").font(.system(size: 20, weight: .regular))
                        
                        HStack(spacing: 5){
                            Text("최고: 33°").font(.system(size: 20, weight: .regular))
                            Text("최저: 22°").font(.system(size: 20, weight: .regular))
                        }
                        .padding(.bottom, 20)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 290)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("5일간의 일기 예보")
                                    Spacer()
                                }
                                Divider()
                                Spacer()
                                ForEach(1..<5) { _ in
                                    HStack{
                                        Text("Five Stars").font(.system(size: 20, weight: .bold))
                                        Image(systemName: "cloud.fill")
                                        Spacer()
                                        Text("25").font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                                        Rectangle().frame(width: 100,height: 1).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                        Text("32").font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                                    }
                                    Divider()
                                }
                                HStack{
                                    Text("Five Stars").font(.system(size: 20, weight: .bold))
                                    Image(systemName: "cloud.fill")
                                    Spacer()
                                    Text("25").font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                                    Rectangle().frame(width: 100,height: 1).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                    Text("32").font(.system(size: 20, weight: .bold)).foregroundStyle(.white.opacity(0.5))
                                }
                                
                            }
                            .padding(.all, 16)
                        }
                        
                }.padding(.horizontal, 16)
            }
        }
        .task {
            await loadCurrentWeather()
            await loadFiveDaysWeather()
        }
    }
}

extension ContentView {
    private func loadCurrentWeather() async {
        do {
            try await currentWeather.getCurrentWeather()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFiveDaysWeather() async {
        do {
            try await fiveDaysWeather.getFiveDaysWeather()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
