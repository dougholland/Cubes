//
//  CubesApp.swift
//  Cubes
//
//  Created by Doug Holland on 6/27/24.
//

import SwiftUI

@main
struct CubesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)
        // set the default volume size to 2 meters in width, height and depth.
        .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
    }
}
