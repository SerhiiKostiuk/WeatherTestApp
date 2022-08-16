//
//  HomeScreenView.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import SwiftUI

struct HomeScreenView: View {
    //MARK: - @StateObject
    @StateObject private var viewModel = HomeScreenViewModel()

    //MARK: - @State

    @State private var selectedId: UInt?
    @State private var isNavigationLinkActive = false
    @State private var isPresentedSetting = false
    @State private var isShowMap = false

    //MARK: - @Environment

    @Environment(\.isSearching) var isSearching

    //MARK: - Body

    var body: some View {
        NavigationView {
            GeometryReader { proxy in

                NavigationLink(isActive: $isNavigationLinkActive) {
                    if let selectedId = selectedId, let model = viewModel.models.first(where: {$0.cityId == selectedId}) {
                        CityWeatherView(model: model)
                    }
                } label: {
                    EmptyView().hidden()
                }.opacity(0.0)

                List(viewModel.filteredModel, id: \.cityId) { model in
                    Button {
                        selectedId = model.cityId
                        isNavigationLinkActive.toggle()
                    } label: {
                        CityCellView(model: model, isShowModal: $isShowMap, selectedId: $selectedId)
                    }.listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Weather")
                .zIndex(1)
            }
            .sheet(isPresented: $isShowMap, content: {
                if isShowMap, let model = viewModel.models.first(where: {$0.cityId == selectedId}) {
                    CityMapView(model: model)
                }
            })
            .overlay(content: {
                VStack {
                    if isPresentedSetting {
                        GeometryReader { proxy in
                            TemperatureScaleView(isShow: $isPresentedSetting).frame(width: proxy.size.width / 2, alignment: .leading)
                                .animation(.default, value: isPresentedSetting)
                                .zIndex(5)
                                .offset(x: proxy.size.width / 2 - 16, y: 0)
                        }
                        .transition(.scale.combined(with: .move(edge: .trailing)))
                        .onTapGesture {
                            isPresentedSetting = false
                        }
                    }
                }.animation(.linear, value: isPresentedSetting)
            })
            .searchable(text: $viewModel.queryString, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isPresentedSetting.toggle()
                        }
                    } label: {
                        Image("view_more_ic")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.all, 10)
                    }

                }
            }
        }
        .onAppear {
            viewModel.getWeather()
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
