//
//  GameScene.swift
//  Squidly
//
//  Created by Connor Wybranowski on 12/30/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let hero: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let score: UInt32 = 0x1 << 4
}

class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    var hero = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = false
    var score = Int()
    let scoreLabel = SKLabelNode()
    var gameOver = Bool()
    var restartButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene() {
        self.physicsWorld.contactDelegate = self
        
        // Add background
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/2.5)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        self.addChild(scoreLabel)
        
        createGround()
        createhero()
    }
    
    func createWalls() {
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        scoreNode.color = SKColor.blue
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2 - 350)
        
        topWall.setScale(0.5)
        bottomWall.setScale(0.5)
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        wallPair.zPosition = 1
        
        // Physics properties
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.hero
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.hero
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
    }
    
    func createhero() {
        hero = SKSpriteNode(imageNamed: "blueSquidStart")
        hero.size = CGSize(width: 50, height: 50)
        hero.position = CGPoint(x: self.frame.width/2 - hero.frame.width, y: self.frame.height/2)
        
        // Physics properties
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.frame.height/2)
        hero.physicsBody?.categoryBitMask = PhysicsCategory.hero
        hero.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.wall
        hero.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.wall | PhysicsCategory.score
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.isDynamic = true
        
        hero.zPosition = 2
        self.addChild(hero)
        
        // Animate hero
        let texture1 = SKTexture(imageNamed: "blueSquidStart")
        let texture2 = SKTexture(imageNamed: "blueSquidMid")
        let texture3 = SKTexture(imageNamed: "blueSquidEnd")
        
        hero.run(SKAction.repeatForever(SKAction.animate(with: [texture1, texture2, texture3], timePerFrame: 0.1)))
    }
    
    func createGround() {
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width/2, y: ground.frame.height/2)
        
        // Physics properties
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.hero
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.zPosition = 3
        self.addChild(ground)
    }
    
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "RestartBtn")
        restartButton.size = CGSize(width: 200, height: 100)
        restartButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
    
    func heroJump() {
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 45))
        hero.physicsBody?.applyAngularImpulse(0.005)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            if gameOver {
                
            } else {
                heroJump()
            }
            
        } else {
            gameStarted = true
            hero.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run {
                () in
                self.createWalls()
            }
            
            // Interval between walls
            let delay = SKAction.wait(forDuration: 2.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            // Make hero jump in beginning
            heroJump()
        }
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if gameOver {
                if restartButton.contains(location) {
                    // Restart game
                    restartScene()
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameStarted {
            if !gameOver {
                enumerateChildNodes(withName: "background", using: { (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 1, y: 0)
                    if bg.position.x <= -bg.size.width {
                        // Background disappeared off scene
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                })

                let velocity = (hero.physicsBody?.velocity.dy)!
                
                hero.zRotation = CGFloat.clamp(min: -1, max: 0.0, value: velocity * (velocity < 0 ? 0.003 : 0.001))
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // Player scored
        if (firstBody.categoryBitMask == PhysicsCategory.score && secondBody.categoryBitMask == PhysicsCategory.hero) || (firstBody.categoryBitMask == PhysicsCategory.hero && secondBody.categoryBitMask == PhysicsCategory.score) {
            score += 1
            scoreLabel.text = "\(score)"
        }
        
        // Player collided with wall or ground
        if ((firstBody.categoryBitMask == PhysicsCategory.hero && secondBody.categoryBitMask == PhysicsCategory.wall) || (firstBody.categoryBitMask == PhysicsCategory.wall && secondBody.categoryBitMask == PhysicsCategory.hero)) || ((firstBody.categoryBitMask == PhysicsCategory.hero && secondBody.categoryBitMask == PhysicsCategory.ground) || (firstBody.categoryBitMask == PhysicsCategory.ground && secondBody.categoryBitMask == PhysicsCategory.hero)){
            
            // Pause all wall pairs
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if !gameOver {
                gameOver = true
                createRestartButton()
            }
        }
    }
}
