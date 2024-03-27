//
//  ContentView.swift
//  FlappyBirdSwiftUIExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 288, height: 512)
        
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
