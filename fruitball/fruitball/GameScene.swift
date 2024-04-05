//
//  GameScene.swift
//  FlappyBirdExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SpriteKit
import GameplayKit
import SwiftUI
import GameKit
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate, GADFullScreenContentDelegate {
    var kick = CGFloat(5)
    
    var rotation: CGFloat = 0.0
    
    var initialPositionY: CGFloat = UIScreen.main.bounds.height - 300
    var initialPositionX: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    
    var score = 0
    
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
    let scoreLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")

    var mudou = false
    
    var start = false
    
    let playLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let pontuacaoLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelStart = SKLabelNode(fontNamed: "SigmarOne-Regular")

    let embaixadinhasLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")

    
    var startGameScene = false
    
    override func didMove(to view: SKView) {
        
#if DEBUG
    // Chave intersticial de teste
InterstitialAd.shared.loadAd(withAdUnitId: "ca-app-pub-3940256099942544/8691691433")
#else
InterstitialAd.shared.loadAd(withAdUnitId: "Sua chave de intersticial")
#endif
        
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
                    
        if startGameScene == false {
            backgroundImage.removeFromParent()
            chaoCampo.removeFromParent()
            goal.removeFromParent()
            scoreNumberLabel.removeFromParent()
            spriteBall.removeFromParent()
            leg.removeFromParent()
            spriteBall.physicsBody?.affectedByGravity = false
            showStartGame()
            self.backgroundColor = UIColor(named: "ColorYellow") ?? SKColor.yellow

        } else {
            embaixadinhasLabel.removeFromParent()
            highscoreLabelTextStart.removeFromParent()
            pontuacaoLabelTextStart.removeFromParent()
            playLabel.removeFromParent()
            highscoreLabelStart.removeFromParent()
            playGame()
            
            start = true
            startGameScene = true
        }
        
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            guard error == nil else {
                print("Erro ao autenticar jogador: \(error!.localizedDescription)")
                return
            }
            if let viewController = viewController {
                self.view?.window?.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    func playGame() {
        
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = CGSize(width: 494*0.65, height: 844*0.65)
        backgroundImage.zPosition = -2
        backgroundImage.removeFromParent()
        addChild(backgroundImage)
        
        chaoCampo.position = CGPoint(x: size.width / 2, y: 20)
        chaoCampo.size = CGSize(width: 423 * 0.7, height: 180 * 0.7)
        chaoCampo.zPosition = -1
        addChild(chaoCampo)
        
        animateChaoCampo()
        
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
        spriteBall.physicsBody?.affectedByGravity = false
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
        
        showScoreAnimation()
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        
        self.physicsWorld.contactDelegate = self
        setupCollision()
    }
    func showStartGame() {
        highscore = UserDefaults.standard.integer(forKey: "highscore")

        embaixadinhasLabel.text = "EMBAIXADINHAS"
        embaixadinhasLabel.fontSize = 20
        embaixadinhasLabel.fontColor = UIColor(named: "ColorScore")
        embaixadinhasLabel.horizontalAlignmentMode = .center
        embaixadinhasLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y:  270)
        addChild(embaixadinhasLabel)
        
        highscoreLabelTextStart.text = "MELHOR"
        highscoreLabelTextStart.fontSize = 20
        highscoreLabelTextStart.fontColor = UIColor(.white)
        highscoreLabelTextStart.horizontalAlignmentMode = .left
        highscoreLabelTextStart.position = CGPoint(x: 35, y:  440)
        addChild(highscoreLabelTextStart)
        
        pontuacaoLabelTextStart.text = "PONTUAÇÃO"
        pontuacaoLabelTextStart.fontSize = 20
        pontuacaoLabelTextStart.fontColor = UIColor(.white)
        pontuacaoLabelTextStart.horizontalAlignmentMode = .left
        pontuacaoLabelTextStart.position = CGPoint(x: 35, y:  420)
        addChild(pontuacaoLabelTextStart)
        
        playLabel.text = "PLAY"
        playLabel.fontSize = 40
        playLabel.fontColor = UIColor(named: "ColorScore")
        playLabel.horizontalAlignmentMode = .center
        playLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y:  80)
        addChild(playLabel)
        
        highscoreLabelStart.text = String(format: "%02d", highscore)
        highscoreLabelStart.fontSize = 180
        highscoreLabelStart.fontColor = UIColor(named: "ColorScore")
        highscoreLabelStart.horizontalAlignmentMode = .center
        highscoreLabelStart.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y: 300)
        addChild(highscoreLabelStart)
    }
    
    func showScoreAnimation() {
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.5)
        scaleUpAction.timingMode = .easeInEaseOut

        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.2)
        scaleDownAction.timingMode = .easeInEaseOut

        let sequence = SKAction.sequence([scaleUpAction, scaleDownAction])

        scoreNumberLabel.run(sequence)
    }
    
    func animateChaoCampo() {
        chaoCampo.position = CGPoint(x: size.width / 2, y: -chaoCampo.size.height)

        let moveUpAction = SKAction.moveTo(y: chaoCampo.size.height / 2, duration: 1.0)
        moveUpAction.timingMode = .easeInEaseOut

        let bounceAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])

        let sequence = SKAction.sequence([moveUpAction, bounceAction])

        chaoCampo.run(sequence)
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
            embaixadinhasLabel.removeFromParent()
            highscoreLabelTextStart.removeFromParent()
            pontuacaoLabelTextStart.removeFromParent()
            playLabel.removeFromParent()
            highscoreLabelStart.removeFromParent()
            self.backgroundColor = UIColor(.white)
            if startGameScene == false {
                playGame()
            }
            start = true
            startGameScene = true
        } else {
            leg.physicsBody?.angularVelocity = 5
            print(leg.zRotation)
            spriteBall.physicsBody?.affectedByGravity = true

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
        if spriteBall.position.y < -scene!.size.height * 1.3 {
            if score > highscore {
                highscore = score
                
                UserDefaults.standard.setValue(highscore, forKey: "highscore")
                UserDefaults.standard.synchronize()
                if GKLocalPlayer.local.isAuthenticated {
                    let score = GKScore(leaderboardIdentifier: "leaderboard")
                    score.value =  Int64(highscore)
                    GKScore.report([score]) { error in
                        if let error = error {
                            print("Erro ao enviar pontuação: \(error.localizedDescription)")
                        } else {
                            print("Pontuação enviada com sucesso!")
                        }
                    }
                }
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
                
//                showIntersticialAd()
                
                let newScene = GameSceneHighscore(size: self.size) // Crie uma nova instância da GameScene
                newScene.scaleMode = self.scaleMode // Configure o modo de escala da nova cena
                newScene.highscore = highscore
                view.presentScene(newScene, transition: .crossFade(withDuration: 1.0)) // Apresente a nova cena com uma transição opcional
            }
            resetBallPosition()

        }
        
        if spriteBall.position.y > heightInTouch * 1.2 && touch == true {
            score += 1
            showScoreAnimation()
            touch = false
            
            if score % 10 == 0 && score != 0{
                if currentFruit < 2 {
                    currentFruit += 1
                } else {
                    currentFruit = 0
                }
                spriteBall.texture = SKTexture(imageNamed: fruits[currentFruit])
                
            }
        }
        
        if leg.zRotation >= 2 {
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        }
        scoreNumberLabel.text =  String(format: "%02d", score)
    }
    
    private func showIntersticialAd() {
        if let ad = InterstitialAd.shared.interstitialAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self.view?.window?.rootViewController)
        }
    }

    func resetBallPosition() {
        if let view = self.view {
            spriteBall.position.y = initialPositionY
            spriteBall.position.x = initialPositionX

            spriteBall.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            spriteBall.physicsBody?.angularVelocity = 0
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            touch = false
            start = false

        }
    }
}
