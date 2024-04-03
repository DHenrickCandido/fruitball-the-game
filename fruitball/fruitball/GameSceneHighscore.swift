//
//  GameSceneHighscore.swift
//  fruitball
//
//  Created by Diego Henrick on 31/03/24.
//

import Foundation

import SpriteKit
import GameKit
import SwiftUI

class GameSceneHighscore: SKScene, SKPhysicsContactDelegate {
    
    var kick = CGFloat(5)
    
    var rotation: CGFloat = 0.0
    
    var initialPositionY: CGFloat = UIScreen.main.bounds.height - 300
    var initialPositionX: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    
    var score: Int = 0
    
    var touch = false
    var heightInTouch = 0.0
    
    var highscore = 0
    
    var spriteBall = SKSpriteNode(imageNamed: "fruitApple")
    
    let leg = SKSpriteNode(imageNamed: "legTorto")
    let scoreNumberLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let chaoCampo = SKSpriteNode(imageNamed: "chaoCampo")
    let goal = SKSpriteNode(imageNamed: "goal")
    let highscoreLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    var leaderboardButtonAdded = false

    let leaderboardButton = UIButton(type: .custom)

    override func didMove(to view: SKView) {
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        chaoCampo.position = CGPoint(x: size.width / 2, y: 20)
        chaoCampo.size = CGSize(width: 423 * 0.7, height: 180 * 0.7)
        chaoCampo.zPosition = -1
        addChild(chaoCampo)
        
        highscoreLabel.text = "HIGHSCORE"
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = UIColor(named: "ColorScoreGrey")
        highscoreLabel.horizontalAlignmentMode = .center
        highscoreLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y: 400)
        addChild(highscoreLabel)
        
        scoreNumberLabel.text = String(format: "%02d", highscore)
        scoreNumberLabel.fontSize = 180
        scoreNumberLabel.fontColor = UIColor(named: "ColorScoreGrey")
        scoreNumberLabel.horizontalAlignmentMode = .center
        scoreNumberLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y: 280)
        addChild(scoreNumberLabel)
        
        rotation = 1
        
        spriteBall.position = CGPoint(x: size.width / 2 + 60, y: 65)
        spriteBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteBall.size = CGSize(width: 50, height: 50)
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        spriteBall.physicsBody = SKPhysicsBody(texture: spriteBall.texture! , size: spriteBall.size)
        spriteBall.physicsBody?.affectedByGravity = false
        spriteBall.physicsBody?.pinned = true
        spriteBall.physicsBody?.allowsRotation = true
        spriteBall.physicsBody?.isDynamic = true
        addChild(spriteBall)
        
        
        leg.size = CGSize(width: 105.6, height: 456)
        leg.position = CGPoint(x: 0, y: 200)
        
        leg.physicsBody = SKPhysicsBody(texture: leg.texture! , size: leg.size)
        leg.physicsBody?.affectedByGravity = false
        leg.physicsBody?.pinned = true
        leg.physicsBody?.allowsRotation = true
        leg.physicsBody?.isDynamic = true
        leg.zRotation = 0.8
        leg.physicsBody?.mass = 5
        leg.physicsBody?.friction = 0.2
        leg.physicsBody?.restitution = 0.2
        leg.physicsBody?.linearDamping = 0.1
        leg.physicsBody?.angularDamping = 0.1
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        addChild(leg)
        
        self.physicsWorld.contactDelegate = self
        
        leaderboardButton.setTitle("Leaderboard", for: .normal)
        leaderboardButton.frame = CGRect(x: 140, y: 50, width: 120, height: 30)
        leaderboardButton.backgroundColor = UIColor.blue
        leaderboardButton.layer.cornerRadius = 10
        leaderboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        leaderboardButton.addTarget(self, action: #selector(showLeaderboard), for: .touchDown)
        self.view?.addSubview(leaderboardButton)
        
//        let leaderboardButton = UIButton(type: .custom)
//        leaderboardButton.setTitle("Leaderboard", for: .normal)
//        leaderboardButton.frame = CGRect(x: 200, y: 50, width: 120, height: 50)
//        leaderboardButton.backgroundColor = UIColor.blue
//        leaderboardButton.layer.cornerRadius = 10
//        leaderboardButton.addTarget(self, action: #selector(showLeaderboard), for: .touchDown)
//        self.view?.addSubview(leaderboardButton)
        
        if !leaderboardButtonAdded {

            
            leaderboardButtonAdded = true
        }
        
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

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        touch = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
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
    
    override func willMove(from view: SKView) {
        // Remover o botão da tela quando a cena for alterada
//        leaderboardButton = nil
    }
    override func update(_ currentTime: TimeInterval) {
        
        if touch == true {

            self.removeAllChildren()
            self.removeAllActions()
            self.removeFromParent()
            leaderboardButton.removeFromSuperview()

            if let view = self.view {
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                view.presentScene(newScene, transition: .crossFade(withDuration: 1.0))
            }
        }
    }
    
    @objc func showLeaderboard() {
        let viewController = self.view?.window?.rootViewController
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = .leaderboards
        gcViewController.leaderboardIdentifier = "leaderboard"
        viewController?.present(gcViewController, animated: true, completion: nil)
        
        
    }
    
    @objc func replay() {
        touch = true
    }

}

extension GameSceneHighscore: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}


