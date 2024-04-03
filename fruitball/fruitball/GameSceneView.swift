//
//  ContentView.swift
//  FlappyBirdSwiftUIExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SwiftUI
import SpriteKit
import GoogleMobileAds

struct GameSceneView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
     
    
#if DEBUG
let bannerAdId = "ca-app-pub-3940256099942544/2435281174"
let rewardAdId = "ca-app-pub-3940256099942544/5224354917"
#else
let bannerAdId = "ca-app-pub-2782621432038890/4981476662"
let rewardAdId = "Seu id de reward"
#endif
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 288, height: 512)
        
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        
        return scene
    }
    
    var body: some View {
        ZStack {
            
            Button("Crash") {
               fatalError("Crash was triggered")
            }
            
            BannerAd(adUnitId: bannerAdId)
            
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
