//
//  ContentView.swift
//  Cubes
//
//  Created by Doug Holland on 6/27/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State var redRotation: Angle = .zero
    @State var blueRotation: Angle = .zero
    @State var greenRotation: Angle = .zero
    
    @State var plane = Entity()
    
    @State var redCube = Entity()
    @State var blueCube = Entity()
    @State var greenCube = Entity()
    
    var body: some View {
        RealityView { content in
            let cubeMesh = MeshResource.generateBox(size: 0.2)
            
            let planeMesh = MeshResource.generatePlane(width: 1.5, depth: 0.8, cornerRadius: 0.15)
            
            let planeMaterial = SimpleMaterial(color: .lightGray, isMetallic: false)
            
            plane = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            
            plane.generateCollisionShapes(recursive: false)
            
            plane.transform.translation = SIMD3<Float>(x: 0, y: -0.65, z: 0)
            
            content.add(plane)
            
            let blueMaterial = SimpleMaterial(color: .blue, isMetallic: false)
            
            blueCube = ModelEntity(mesh: cubeMesh, materials: [blueMaterial])
            
            blueCube.name = "Blue Cube"
            
            blueCube.components.set(InputTargetComponent())
            
            blueCube.components.set(GroundingShadowComponent(castsShadow: true))

            blueCube.generateCollisionShapes(recursive: false)
            
            content.add(blueCube)
            
            let redMaterial = SimpleMaterial(color: .red, isMetallic: false)
            
            redCube = ModelEntity(mesh: cubeMesh, materials: [redMaterial])
            
            redCube.name = "Red Cube"
            
            redCube.components.set(InputTargetComponent())
            
            redCube.components.set(GroundingShadowComponent(castsShadow: true))
            
            redCube.generateCollisionShapes(recursive: false)

            redCube.transform.translation = SIMD3<Float>(x: -0.5, y: 0, z: 0)
            
            content.add(redCube)
            
            let greenMaterial = SimpleMaterial(color: .green, isMetallic: false)
            
            greenCube = ModelEntity(mesh: cubeMesh, materials: [greenMaterial])
            
            greenCube.name = "Green Cube"
            
            greenCube.components.set(InputTargetComponent())
            
            greenCube.components.set(GroundingShadowComponent(castsShadow: true))
            
            greenCube.generateCollisionShapes(recursive: false)
            
            greenCube.transform.translation = SIMD3<Float>(x: 0.5, y: 0, z: 0)
            
            content.add(greenCube)
            
            // rotate the cube 45 degrees on the x and y axis.
            blueCube.transform.rotation = simd_quatf(angle: 22, axis: SIMD3(x: 0, y: 1, z: 0))
            
            blueCube.transform.rotation = simd_quatf(angle: 45, axis: SIMD3(x: 1, y: 0, z: 0))
        } update: { content in
        /*
            if let scene = content.entities.first {
                Task {
                    
                }
            }
         */
        }
        .gesture(
            DragGesture()
                .targetedToEntity(redCube)
                .onChanged { _ in
                    redRotation.degrees += 4.0
                    
                    let matrix1 = Transform(pitch: Float(redRotation.radians)).matrix
                    let matrix2 = Transform(yaw: Float(redRotation.radians)).matrix
                    
                    redCube.transform.matrix = matrix_multiply(matrix1, matrix2)
                    
                    redCube.position.x = -0.5
                }
        )
        .gesture(
            DragGesture()
                .targetedToEntity(greenCube)
                .onChanged { _ in
                    greenRotation.degrees += 4.0
                    
                    let matrix1 = Transform(pitch: Float(greenRotation.radians)).matrix
                    let matrix2 = Transform(yaw: Float(greenRotation.radians)).matrix
                    
                    greenCube.transform.matrix = matrix_multiply(matrix1, matrix2)
                    
                    greenCube.position.x = 0.5
                }
        )
        .gesture(
            DragGesture()
                .targetedToEntity(blueCube)
                .onChanged { _ in
                    blueRotation.degrees += 4.0
                    
                    let matrix1 = Transform(pitch: Float(blueRotation.radians)).matrix
                    let matrix2 = Transform(yaw: Float(blueRotation.radians)).matrix
                    
                    blueCube.transform.matrix = matrix_multiply(matrix1, matrix2)
                }
        )
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
