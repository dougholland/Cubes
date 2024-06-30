//
//  ContentView.swift
//  RealityKitCubes
//
//  Created by Doug Holland on 4/13/24.
//

import SwiftUI
import RealityKit

//@MainActor
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
    
    @State var gravity = false
    
    var body: some View {
        RealityView { content in
            let cubeMesh = MeshResource.generateBox(size: 0.2)
            
            let planeMesh = MeshResource.generatePlane(width: 1.5, depth: 0.8, cornerRadius: 0.15)
            
            let planeShape = [ShapeResource.generateBox(size: [1.5, 0.01, 0.8])]
            
            let planeMaterial = SimpleMaterial(color: .lightGray, isMetallic: false)
            
            plane = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            
            plane.name = "Plane"
            
            plane.components.set(CollisionComponent(shapes: planeShape))
            
            var planePhysicsBody = PhysicsBodyComponent(shapes: planeShape, mass: 1.0, material: .default, mode: .dynamic)
            
            planePhysicsBody.mode = .static
            
            plane.components.set(planePhysicsBody)
            
            plane.generateCollisionShapes(recursive: false)
            
            plane.transform.translation = SIMD3<Float>(x: 0, y: -1.0, z: 0)
            
            content.add(plane)
            
            let blueMaterial = SimpleMaterial(color: .blue, isMetallic: false)
            
            blueCube = ModelEntity(mesh: cubeMesh, materials: [blueMaterial])
            
            blueCube.name = "Blue Cube"
            
            let cubeShape = [ShapeResource.generateBox(size: [0.2, 0.2, 0.2])]
            
            var cubePhysicsBody = PhysicsBodyComponent(shapes: cubeShape, mass: 1.0, material: .default, mode: .dynamic)
            
            cubePhysicsBody.mode = .static
            
            blueCube.components.set(cubePhysicsBody)
            
            blueCube.components.set(CollisionComponent(shapes: cubeShape))
            
            blueCube.components.set(InputTargetComponent())
            
            blueCube.components.set(GroundingShadowComponent(castsShadow: true))

            blueCube.generateCollisionShapes(recursive: false)
            
            print("blueCube.position = \(blueCube.position)")
            print("blueCube.transform.rotation = \(blueCube.transform.rotation)")
            
            blueCube.transform.translation = SIMD3<Float>(x: 0, y: -0.5, z: 0)
            
            content.add(blueCube)
            
            let redMaterial = SimpleMaterial(color: .red, isMetallic: false)
            
            redCube = ModelEntity(mesh: cubeMesh, materials: [redMaterial])
            
            redCube.name = "Red Cube"
            
            redCube.components.set(cubePhysicsBody)
            
            redCube.components.set(InputTargetComponent())
            
            redCube.components.set(GroundingShadowComponent(castsShadow: true))
            
            redCube.generateCollisionShapes(recursive: false)

            redCube.transform.translation = SIMD3<Float>(x: -0.5, y: -0.5, z: 0)
            
            print("redCube.position = \(redCube.position)")
            print("redCube.transform.rotation = \(redCube.transform.rotation)")
            
            content.add(redCube)
            
            let greenMaterial = SimpleMaterial(color: .green, isMetallic: false)
            
            greenCube = ModelEntity(mesh: cubeMesh, materials: [greenMaterial])
            
            greenCube.name = "Green Cube"
            
            greenCube.components.set(cubePhysicsBody)
            
            greenCube.components.set(InputTargetComponent())
            
            greenCube.components.set(GroundingShadowComponent(castsShadow: true))
            
            greenCube.generateCollisionShapes(recursive: false)
            
            greenCube.transform.translation = SIMD3<Float>(x: 0.5, y: -0.5, z: 0)
            
            print("greenCube.position = \(greenCube.position)")
            print("greenCube.transform.rotation = \(greenCube.transform.rotation)")
            
            content.add(greenCube)
            
            // _ = advises Swift to ignore the return value.
            _ = content.subscribe(to: CollisionEvents.Began.self, on: redCube) { event in
                print("collision started \(event.entityA.name), \(event.entityB.name))")
                Task {
                    try? await playCollisionAudio(from: redCube)
                }
            }
            
            _ = content.subscribe(to: CollisionEvents.Began.self, on: greenCube) { event in
                print("collision started \(event.entityA.name), \(event.entityB.name))")
                Task {
                    try? await playCollisionAudio(from: greenCube)
                }
            }
            
            _ = content.subscribe(to: CollisionEvents.Began.self, on: blueCube) { event in
                print("collision started \(event.entityA.name), \(event.entityB.name))")
                Task {
                    try? await playCollisionAudio(from: blueCube)
                }
            }
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
                    
                    redCube.position.y = -0.5
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
                    
                    greenCube.position.y = -0.5
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
                    
                    blueCube.position.y = -0.5
                }
        )
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Button("Reset", systemImage: "globe") {
                    reset()
                }
            }
            
            ToolbarItem(placement: .bottomOrnament) {
                Toggle(isOn: $gravity, label: {
                    Text("Gravity")
                })
                .onChange(of: gravity) { oldValue, newValue in
                    if gravity {
                        enableGravity()
                    }
                }
            }
        }
    }
    
    func enableGravity() {
        redCube.components[PhysicsBodyComponent.self]?.mode = .dynamic
        
        blueCube.components[PhysicsBodyComponent.self]?.mode = .dynamic
        
        greenCube.components[PhysicsBodyComponent.self]?.mode = .dynamic
    }
    
    func reset() {
        gravity = false
        
        redCube.components[PhysicsBodyComponent.self]?.mode = .static
        redCube.position = SIMD3<Float>(-0.5, -0.5, 0.0)
        redCube.transform.rotation = simd_quatf(angle: 0, axis: SIMD3(x: 1, y: 1, z: 1))
        
        blueCube.components[PhysicsBodyComponent.self]?.mode = .static
        blueCube.position = SIMD3<Float>(0.0, -0.5, 0.0)
        blueCube.transform.rotation = simd_quatf(angle: 0, axis: SIMD3(x: 1, y: 1, z: 1))
        
        greenCube.components[PhysicsBodyComponent.self]?.mode = .static
        greenCube.position = SIMD3<Float>(0.5, -0.5, 0.0)
        greenCube.transform.rotation = simd_quatf(angle: 0, axis: SIMD3(x: 1, y: 1, z: 1))
    }
    
    @MainActor
    func playCollisionAudio(from cube: Entity) async throws {
        let resource = try await AudioFileResource(named: "CubeCollision", configuration: AudioFileResource.Configuration(shouldLoop: false, shouldRandomizeStartTime: false))
        
        // without @MainActor - await cube.playAudio(resource)
        let controller: AudioPlaybackController = cube.playAudio(resource)
        
        // controller.gain = -.infinity
        
        controller.fade(to: .zero, duration: 0.4)
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
