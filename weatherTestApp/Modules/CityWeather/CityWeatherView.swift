//
//  CityWeatherView.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import SwiftUI
import Kingfisher

struct CityWeatherView: View {

    //MARK: - @AppStorage

    @AppStorage(KeyPreference.temperatureScale.rawValue, store: .standard) var temperatureScale: TemperatureScale = .kelvin

    //MARK: - @StateObject
    @StateObject private var viewModel = CityWeatherViewModel()

    //MARK: - Private Property

    private let model: WeatherDTO

    //MARK: - Initializer

    init(model: WeatherDTO) {
        self.model = model
    }

    //MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(spacing: 12) {
                Text(model.cityName)
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                Text(getFormattedDate(from: model.date).capitalized)
                    .font(.system(size: 22, weight: .medium, design: .rounded))

                if let weatherMain = model.weatherMain {
                    Text("\(temperatureScale.convert(temperature: weatherMain.temp))\(temperatureScale.sign)")
                        .font(Font.system(size: 32, weight: .heavy, design: .rounded))
                }

            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 30).padding(.bottom, 15)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(viewModel.models, id: \.date) { model in
                        createCell(for: model)
                            .id(model.date)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getForecast(for: model.cityId)
        }
    }

    //MARK: - Private Func

    @ViewBuilder private func createCell(for model: ForecastDTO) -> some View {
        HStack(spacing: 20) {
            VStack(alignment: .center, spacing: 0) {

                Text("\(getFormattedDate(from: model.date).capitalized), \(getFormattedTime(from: model.date))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 16, weight: .medium, design: .rounded))

                Group {
                    if let weatherInfo = model.weatherInfo {
                        ForEach(weatherInfo, id: \.id) { info in
                            HStack(spacing: 8) {
                                KFImage(URL(string: "https://openweathermap.org/img/wn/\(info.iconName)@2x.png"))
                                    .fade(duration: 0.25)
                                    .placeholder {
                                        Image("placeholder_image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    }
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)

                                Text(info.description.uppercased())
                                    .font(Font.system(size: 12, weight: .medium, design: .rounded))
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }.frame(maxHeight: .infinity, alignment: .bottom)
            }
            if let weatherMain = model.weatherMain {
                VStack(alignment: .leading, spacing: 10) {
                    Text("H:\(temperatureScale.convert(temperature: weatherMain.maxTemp))\(temperatureScale.sign)")
                        .foregroundColor(Color.red)

                    Text("L:\(temperatureScale.convert(temperature: weatherMain.minTemp))\(temperatureScale.sign)")
                        .foregroundColor(Color.blue)

                }
                .opacity(0.7)
                .font(Font.system(size: 18, weight: .medium, design: .rounded))
            }

        }
        .foregroundColor(Color.white)
        .padding(.all, 16)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray))
    }

    private func getFormattedDate(from timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        if Calendar.current.isDateInToday(date) {
            return "Today"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    private func getFormattedTime(from timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }

}

