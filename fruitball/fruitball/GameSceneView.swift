//
//  ContentView.swift
//  FlappyBirdSwiftUIExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            scene.view?.showsPhysics = true
            
              return scene
        }
            return SKScene()
      }
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
