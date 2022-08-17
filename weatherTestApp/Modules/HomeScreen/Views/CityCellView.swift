//
//  CityCellView.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct CityCellView: View {
    
    // MARK: - @AppStorage
    @AppStorage(KeyPreference.temperatureScale.rawValue, store: .standard) var temperatureScale: TemperatureScale = .kelvin

    //MARK: - Private @Binding
    @Binding private var isShowModal: Bool
    @Binding private var selectedId: UInt?

    //MARK: - Private Property
    private let model: WeatherDTO
    
    //MARK: - Initializer
    init(model: WeatherDTO, isShowModal: Binding<Bool>, selectedId: Binding<UInt?>) {
        self.model = model
        self._isShowModal = isShowModal
        self._selectedId = selectedId
    }
    
    //MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center, spacing: 8) {
                    Text(model.cityName)
                        .font(Font.system(size: 20, weight: .heavy, design: .rounded))
                    
                    Button {
                        selectedId = model.cityId
                        isShowModal.toggle()
                    } label: {
                        Image("map")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                if let weatherInfo = model.weatherInfo {
                    
                    Spacer(minLength: 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(weatherInfo, id: \.id) { info in
                            Text(info.description.uppercased())
                                .font(Font.system(size: 12, weight: .medium, design: .rounded))
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 0) {
                if let weatherInfo = model.weatherInfo {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(weatherInfo, id: \.id) { info in
                            
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
                            
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                    
                    Spacer(minLength: 12)
                }
                
                if let weatherMain = model.weatherMain {
                    Text("H:\(temperatureScale.convert(temperature: weatherMain.maxTemp))\(temperatureScale.sign)  L:\(temperatureScale.convert(temperature: weatherMain.minTemp))\(temperatureScale.sign)")
                        .font(Font.system(size: 12, weight: .medium, design: .rounded))
                }
            }
        }
        .foregroundColor(Color.white)
        .padding(.all, 10.0)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray))
    }
}
