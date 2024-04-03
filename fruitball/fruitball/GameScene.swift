//
//  GameScene.swift
//  FlappyBirdExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SpriteKit
import GameplayKit
import SwiftUI
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate, GADFullScreenContentDelegate {
    var kick = CGFloat(5)
    
    var rotation: CGFloat = 0.0
    
    var initialPositionY: CGFloat = UIScreen.main.bounds.height - 300
    var initialPositionX: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    
    var score: Int = 0
    
    var touch = false
    var heightInTouch = 0.0
    
    var highscore = 0
    
    var fruits = ["fruitApple", "watermelon", "banana"]
    var currentFruit = 0
    
    var spriteBall = SKSpriteNode(imageNamed: "fruitApple")
    let leg = SKSpriteNode(imageNamed: "legTorto")
    let scoreNumberLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let backgroundImage = SKSpriteNode(imageNamed: "backgroundPark")
    let chaoCampo = SKSpriteNode(imageNamed: "chaoCampo")
    let goal = SKSpriteNode(imageNamed: "goal")
    
    var mudou = false
    
    var start = false
    
    
    
    override func didMove(to view: SKView) {
        
#if DEBUG
    // Chave intersticial de teste
InterstitialAd.shared.loadAd(withAdUnitId: "ca-app-pub-3940256099942544/8691691433")
#else
InterstitialAd.shared.loadAd(withAdUnitId: "Sua chave de intersticial")
#endif
        
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = CGSize(width: 494*0.65, height: 844*0.65)
        backgroundImage.zPosition = -2
        backgroundImage.removeFromParent()
        addChild(backgroundImage)
        
        chaoCampo.position = CGPoint(x: size.width / 2, y: 20)
        chaoCampo.size = CGSize(width: 423 * 0.7, height: 180 * 0.7)
        chaoCampo.zPosition = -1
        addChild(chaoCampo)
        
        goal.position = CGPoint(x: size.width / 2, y: size.height / 2 - 55)
        goal.size = CGSize(width: 400 * 0.7, height: 227 * 0.7)
        goal.zPosition = -1
        addChild(goal)
        
        scoreNumberLabel.text = String(format: "%02d", score)
        scoreNumberLabel.fontSize = 180
        scoreNumberLabel.fontColor = UIColor(named: "ColorScore")
        scoreNumberLabel.horizontalAlignmentMode = .center
        scoreNumberLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y: 330)
        addChild(scoreNumberLabel)
        
        rotation = 1
        
        spriteBall.position = CGPoint(x: initialPositionX, y: initialPositionY )
        spriteBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteBall.size = CGSize(width: 50, height: 50)
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        
        spriteBall.physicsBody = SKPhysicsBody(texture: spriteBall.texture! , size: spriteBall.size)
        addChild(spriteBall)
        
        
        leg.size = CGSize(width: 105.6, height: 456)
        leg.position = CGPoint(x: 0, y: 200)
        
        leg.physicsBody = SKPhysicsBody(texture: leg.texture! , size: leg.size)
        leg.physicsBody?.affectedByGravity = false
        leg.physicsBody?.pinned = true
        leg.physicsBody?.allowsRotation = true
        leg.physicsBody?.isDynamic = true
        leg.zRotation = rotation
        leg.physicsBody?.mass = 5
        leg.physicsBody?.friction = 0.2
        leg.physicsBody?.restitution = 0.2
        leg.physicsBody?.linearDamping = 0.1
        leg.physicsBody?.angularDamping = 0.1
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        addChild(leg)
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        
        self.physicsWorld.contactDelegate = self
        setupCollision()
            
        if start == false {
            spriteBall.physicsBody?.affectedByGravity = false
        } else {
            spriteBall.physicsBody?.affectedByGravity = true
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact!!!")
        spriteBall.physicsBody?.velocity.dy = 400
        print(score)
        touch = true
        heightInTouch = spriteBall.position.y
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func setupCollision() {
        let contactCategoryBall: UInt32 = 0x1 << 0
        let contactCategoryLeg: UInt32 = 0x1 << 1
        
        spriteBall.physicsBody?.categoryBitMask = contactCategoryBall
        leg.physicsBody?.categoryBitMask = contactCategoryLeg
        
        spriteBall.physicsBody?.collisionBitMask = contactCategoryLeg
        
        spriteBall.physicsBody?.contactTestBitMask = contactCategoryLeg
    }

    func touchDown(atPoint pos : CGPoint) {
        if start == false {
            start = true
            spriteBall.physicsBody?.affectedByGravity = true
        } else {
            leg.physicsBody?.angularVelocity = 5
            print(leg.zRotation)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        leg.physicsBody?.angularVelocity = 0
        leg.zRotation = rotation
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Verifica se a bola está fora da tela
        if spriteBall.position.y < -scene!.size.height * 1.3 {
            // Reposiciona a bola para o início
           
            if score > highscore {
                highscore = score
                
                UserDefaults.standard.setValue(highscore, forKey: "highscore")
                UserDefaults.standard.synchronize()
//                highscoreNumberLabel.text = String(highscore)
            }
            
            score = 0
            
            if let view = self.view {
                backgroundImage.removeFromParent()
                chaoCampo.removeFromParent()
                goal.removeFromParent()
                scoreNumberLabel.removeFromParent()
                spriteBall.removeFromParent()
                leg.removeFromParent()
                start = false
                
                showIntersticialAd()
                
                let newScene = GameSceneHighscore(size: self.size) // Crie uma nova instância da GameScene
                newScene.scaleMode = self.scaleMode // Configure o modo de escala da nova cena
                newScene.highscore = highscore
                view.presentScene(newScene, transition: .crossFade(withDuration: 1.0)) // Apresente a nova cena com uma transição opcional
            }
            resetBallPosition()
        }
        
        if spriteBall.position.y > heightInTouch * 1.2 && touch == true {
            score += 1
            touch = false
            
            if score % 10 == 0 && score != 0{
                if currentFruit < 2 {
                    currentFruit += 1
                } else {
                    currentFruit = 0
                }
                spriteBall.texture = SKTexture(imageNamed: fruits[currentFruit])
//                spriteBall.physicsBody = SKPhysicsBody(texture: spriteBall.texture! , size: spriteBall.size)
                
            }
        }
        
////        print(leg.zRotation)
        if leg.zRotation >= 2 {
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        }
//        
        scoreNumberLabel.text =  String(format: "%02d", score)

    }
    
    private func showIntersticialAd() {
        if let ad = InterstitialAd.shared.interstitialAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self.view?.window?.rootViewController)
        }
    }

    func resetBallPosition() {
        // Reposiciona a bola para o início
        if let view = self.view {
            spriteBall.position.y = initialPositionY
            spriteBall.position.x = initialPositionX

            spriteBall.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            spriteBall.physicsBody?.angularVelocity = 0
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            touch = false


        }
    }
}
