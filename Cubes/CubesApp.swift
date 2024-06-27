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

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
