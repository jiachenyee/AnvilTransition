//
//  ContentView.swift
//  AnvilTransition
//
//  Created by Jia Chen Yee on 24/8/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State var showItem = false
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                if showItem {
                    Text("ANVIL TRANSITION")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.anvil)
                }
                
                Button("ANVIL") {
                    withAnimation(.linear(duration: 0.5)) {
                        showItem.toggle()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AnyTransition {
    static var anvil: AnyTransition {
        get {
            AnyTransition.modifier(
                active: AnvilModifier(progress: 0),
                identity: AnvilModifier(progress: 1))
        }
    }
}

struct AnvilModifier: ViewModifier, Animatable {
    
    var progress: Double
    
    var animatableData: CGFloat {
        get {
            progress
        } set {
            progress = newValue
        }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            
            HStack(spacing: 0) {
                if progress > 0.4 {
                    
                    AnvilView()
                        .frame(width: 216, height: 216)
                        .rotation3DEffect(.degrees(180), axis: (0, 1, 0))
                    AnvilView()
                        .frame(width: 216, height: 216)
                }
            }
            .frame(height: 216)
            content
                .modifier(FlyTransition(progress: progress < 0.5 ? progress * 2 : 1))
        }
    }
}

struct AnvilView: UIViewRepresentable {
    
    let emitterNode = SKEmitterNode(fileNamed: "Smoke.sks")!
    
    func makeUIView(context: Context) -> SKView {
        let scene = SKScene()
        
        emitterNode.position = .init(x: 0, y: 0)
        emitterNode.emissionAngle = .pi / 20
        emitterNode.name = "Emitter"
        emitterNode.particleBirthRate = 10000
        
        emitterNode.particleLifetime = 0.5
        emitterNode.particleLifetimeRange = 0.1
        
        emitterNode.particleRotationRange = .pi / 3
        emitterNode.particleRotation = .pi / 4
        
        emitterNode.particleSize = .init(width: 1, height: 1)
        emitterNode.particleScaleRange = 100
        
        emitterNode.particleAlpha = 0.5
        emitterNode.particleAlphaRange = 0.5
        
        emitterNode.particleSpeed = 5
        emitterNode.particleSpeedRange = 500
        
        scene.addChild(emitterNode)
        scene.size = CGSize(width: 216, height: 216)
        scene.scaleMode = .fill
        scene.backgroundColor = .clear
        
        let view = SKView()
        
        view.presentScene(scene)
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            emitterNode.particleBirthRate = 0
        }
    }
}

struct FlyTransition: GeometryEffect {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        let newProgress = pow(progress, 3)
        
        return ProjectionTransform(.init(translationX: 0, y: size.height - size.height / newProgress))
    }
}
