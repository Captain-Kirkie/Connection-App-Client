//
//  ContentView.swift
//  Connection_Client
//
//  Created by Kirk Hietpas on 10/19/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    
    var body: some View {
        NavigationStack {
            VStack {
                MapView()
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Settings tapped!")
                    }) {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Add tapped!")
                    }) {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("First") { print("First tapped") }
                        Spacer()
                        Button("Second") { print("Second tapped") }
                    }
                }
            }
        }
    }
}


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7606, longitude: -111.8881), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    var body: some View {
        let mapCameraPosition = MapCameraPosition.region(mapRegion)
        Map(initialPosition: mapCameraPosition) {
            // why isnt this working??
            UserAnnotation()
        }
        .onAppear {
            if let userLocation = locationManager.userLocation {
                mapRegion.center = userLocation
            }
        }
        .onChange(of: locationManager.userLocation?.latitude) { oldLat, newLat in
            if let newLat = newLat, let oldLong =  locationManager.userLocation?.longitude{
                let newCenter = CLLocationCoordinate2D(latitude: newLat, longitude: oldLong)
                mapRegion.center = newCenter
            }
        }
        .onChange(of: locationManager.userLocation?.longitude) { oldLong, newLong in
            if let newLong = newLong, let oldLat =  locationManager.userLocation?.latitude{
                let newCenter = CLLocationCoordinate2D(latitude: oldLat, longitude: newLong)
                mapRegion.center = newCenter
            }
        }
        //         Optional: Add a button to recenter the map on the user's location
        .mapControls {
            // does this work? probably not....
            MapUserLocationButton()
        }
        
    }
    
}
#Preview {
    ContentView()
}
