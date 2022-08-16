//
//  CityMapView.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct CityMapView: View {
    // MARK: - @Environment
    @Environment(\.presentationMode) var presentationMode

    // MARK: - @State
    @State private var mapRegion: MKCoordinateRegion

    //MARK: - Private Func
    private let model: WeatherDTO
    private let locations: [Location]

    //MARK: - Initializer
    init(model: WeatherDTO) {
        self.model = model

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: model.coordinates.latitude, longitude: model.coordinates.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self._mapRegion = State(initialValue: region)
        self.locations = [Location(name: "", coordinate: CLLocationCoordinate2D(latitude: model.coordinates.latitude, longitude: model.coordinates.longitude))]
    }

    //MARK: - Body
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {

                   Image("map_pin").frame(width: 20, height: 20)
                }
            }
            .navigationTitle(model.cityName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("close")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.all, 10)
                    }

                }
            }
        }
    }
}
