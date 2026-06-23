
import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        RealityView { content in
            let ball = ModelEntity(mesh: .generateSphere(radius: 0.05),
                                   materials: [SimpleMaterial(color: .red, isMetallic: false)])
            ball.position = [0, 0, -0.5]
            
            // Collision so it can bounce
            ball.generateCollisionShapes(recursive: false)
            
            // Kinematic mode: you directly set velocity
            ball.physicsBody = PhysicsBodyComponent(massProperties: .default,
                                                     material: .default,
                                                     mode: .kinematic)
            ball.physicsMotion = PhysicsMotionComponent(linearVelocity: [0.2, 0.3, 0.1],
                                                        angularVelocity: [0,0,0])
            
            content.add(ball)
            
            // Example of bouncing logic via timer (if desired)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                let p = ball.position
                var motion = ball.physicsMotion!
                if abs(p.x) > 1 { motion.linearVelocity.x *= -1 }
                if abs(p.y) > 1 { motion.linearVelocity.y *= -1 }
                if abs(p.z + 0.5) > 1 { motion.linearVelocity.z *= -1 }
                ball.physicsMotion = motion
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
