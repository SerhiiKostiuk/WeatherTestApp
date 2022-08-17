//
//  TemperatureScaleView.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation
import SwiftUI

struct TemperatureScaleView: View {

    //MARK: - AppStorage
    @AppStorage(KeyPreference.temperatureScale.rawValue, store: .standard) var temperatureScale: TemperatureScale = .kelvin

    //MARK: - @Binding
    @Binding private var isShow: Bool

    //MARK: - Initializer
    init(isShow: Binding<Bool>) {
        self._isShow = isShow
    }

    //MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            ForEach(TemperatureScale.allCases, id: \.rawValue) { scale in
                Button {
                    temperatureScale = scale

                    withAnimation {
                        isShow.toggle()
                    }
                } label: {
                    Text(scale.title)
                        .foregroundColor(Color.white)
                        .font(Font.body)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if temperatureScale == scale {
                        Image("checkmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.8)))
    }
}
