//
//  GameSceneStart.swift
//  fruitball
//
//  Created by Diego Henrick on 04/04/24.
//

import Foundation

import SpriteKit
import GameKit
import SwiftUI

class GameSceneStart: SKScene, SKPhysicsContactDelegate {
    
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
    let playLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let pontuacaoLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")

    let embaixadinhasLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")


    let chaoCampo = SKSpriteNode(imageNamed: "chaoCampo")
    let goal = SKSpriteNode(imageNamed: "goal")
    let highscoreLabelStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    var leaderboardButtonAdded = false


    override func didMove(to view: SKView) {
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        self.backgroundColor = UIColor(named: "ColorYellow") ?? SKColor.yellow

        
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
        
        rotation = 1


        
        self.physicsWorld.contactDelegate = self
        
//        leaderboardButton.setTitle("Leaderboard", for: .normal)
//        leaderboardButton.frame = CGRect(x: 140, y: 50, width: 120, height: 30)
//        leaderboardButton.backgroundColor = UIColor.blue
//        leaderboardButton.layer.cornerRadius = 10
//        leaderboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        leaderboardButton.addTarget(self, action: #selector(showLeaderboard), for: .touchDown)
//        self.view?.addSubview(leaderboardButton)
    }

    
    
    func touchDown(atPoint pos : CGPoint) {
        self.removeFromParent()
        self.removeAllChildren()
        embaixadinhasLabel.removeFromParent()
        highscoreLabelTextStart.removeFromParent()
        pontuacaoLabelTextStart.removeFromParent()
        playLabel.removeFromParent()
        highscoreLabelStart.removeFromParent()
        
        
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            view.presentScene(newScene, transition: .crossFade(withDuration: 1.0))
        }

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
//        leaderboardButton.removeFromSuperview()
    }
    override func update(_ currentTime: TimeInterval) {
        
        if touch == true {
            
            
        }
    }
    
//    @objc func showLeaderboard() {
//        let viewController = self.view?.window?.rootViewController
//        let gcViewController = GKGameCenterViewController()
//        gcViewController.gameCenterDelegate = self
//        gcViewController.viewState = .leaderboards
//        gcViewController.leaderboardIdentifier = "leaderboard"
//        viewController?.present(gcViewController, animated: true, completion: nil)
//    }
//    
//    @objc func replay() {
//        touch = true
//    }

}

//extension GameSceneHighscore: GKGameCenterControllerDelegate {
//    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
//        gameCenterViewController.dismiss(animated: true, completion: nil)
//    }
//}


