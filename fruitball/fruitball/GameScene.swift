//
//  GameScene.swift
//  FlappyBirdExample
//
//  Created by Luiz Veloso on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKSpriteNode!
    var leg: SKSpriteNode!
    var scoreNumberLabel: SKLabelNode!
    var highscoreNumberLabel: SKLabelNode!
    
    var kick = CGFloat(5)
    
    var rotation: CGFloat = 0.0
    
    var initialPositionY: CGFloat = 0.0
    var initialPositionX: CGFloat = 0.0
    
    var score: Int = 0
    
    var touch = false
    var heightInTouch = 0.0
    
    var highscore = 0
    
    override func didMove(to view: SKView) {
        ball = childNode(withName: "ball") as? SKSpriteNode
//        legNode = childNode(withName: "legNode")
        leg = childNode(withName: "leg") as? SKSpriteNode
        
//        leg.physicsBody = SKPhysicsBody(rectangleOf: leg.size, center: CGPoint(x: -500, y: -40))
        scoreNumberLabel = childNode(withName: "scoreNumberLabel") as? SKLabelNode
        highscoreNumberLabel = childNode(withName: "highscoreNumberLabel") as? SKLabelNode
        
        var halfHeight = leg.frame.size.height / 2.0;
        
        scoreNumberLabel.text = String(0)
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscoreNumberLabel.text = String(highscore)
        
        leg.physicsBody?.affectedByGravity = false
        
        rotation = leg.zRotation
        initialPositionY = ball.position.y
        initialPositionX = ball.position.x
        self.physicsWorld.contactDelegate = self
        setupCollision()
        print("setup")
    }
    
    //5.2 Detecta o contato
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact!!!")
        
        self.ball.physicsBody?.velocity.dy = 400
//        score += 1
        print(score)
        touch = true
        heightInTouch = self.ball.position.y
    }
    
    func setupCollision() {
        let contactCategoryBall: UInt32 = 0x1 << 0   // bitmask is ...00000001
        let contactCategoryLeg: UInt32 = 0x1 << 1
        
        ball.physicsBody?.categoryBitMask = contactCategoryBall
        leg.physicsBody?.categoryBitMask = contactCategoryLeg
        
        ball.physicsBody?.collisionBitMask = contactCategoryLeg
        
        ball.physicsBody?.contactTestBitMask = contactCategoryLeg
        

        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        leg.physicsBody?.angularVelocity = 5
//        leg.zRotation = 80
        print(leg.zRotation)
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        leg.physicsBody?.angularVelocity = 0
        leg.zRotation = rotation
        
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
        if ball.position.y < -scene!.size.height * 2 {
            // Reposiciona a bola para o início
            resetBallPosition()
            if score > highscore {
                highscore = score
                UserDefaults.standard.setValue(highscore, forKey: "highscore")
                UserDefaults.standard.synchronize()
                highscoreNumberLabel.text = String(highscore)
            }
            score = 0
        }
        
        if ball.position.y > heightInTouch * 1.6 && touch == true {
            score += 1
            touch = false

        }
        
//        print(leg.zRotation)
        if leg.zRotation >= 1.9 {
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
        }
        
        scoreNumberLabel.text = String(score)
    }

    func resetBallPosition() {
        // Reposiciona a bola para o início
        if let view = self.view {
            ball.position.y = initialPositionY
            ball.position.x = initialPositionX

            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.angularVelocity = 0
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            


        }
    }
}
