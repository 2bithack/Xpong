//
//  GameScene.swift
//  Xpong
//
//  Created by enzo bot on 4/24/16.
//  Copyright (c) 2016 bot. All rights reserved.
//

import SpriteKit
import Foundation

let ball = SKSpriteNode(imageNamed: "ball")
var player1 = SKSpriteNode(imageNamed: "playerbar")
var player1HitBox = SKSpriteNode(imageNamed: "playerbar2")
var player1SwipeBox = SKSpriteNode(imageNamed: "playerSwipeBox")
let player2 = SKSpriteNode(imageNamed: "playerbar")
var player2HitBox = SKSpriteNode(imageNamed: "playerbar3")
var player2SwipeBox = SKSpriteNode(imageNamed: "playerSwipeBox")
let background = SKSpriteNode(imageNamed: "xpongbackground")
let goal1 = SKSpriteNode(imageNamed: "goal")
let goal2 = SKSpriteNode(imageNamed: "goal")
let border1 = SKSpriteNode(imageNamed: "border")
let border2 = SKSpriteNode(imageNamed: "border")
let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
let playButton = SKSpriteNode(imageNamed: "playButton")
let resetButton = SKSpriteNode(imageNamed: "resetButton")
var player2WinsLabel: SKLabelNode!
var player1WinsLabel: SKLabelNode!
var player2WinsLabel2: SKLabelNode!
var player1WinsLabel2: SKLabelNode!
let readyButton1 = SKSpriteNode(imageNamed: "readyButton")
let readyButton2 = SKSpriteNode(imageNamed: "readyButton")
let exitButton = SKSpriteNode(imageNamed: "exitButton")
var startMessage: SKLabelNode!

var driveHit1: Bool = false
var driveHit2: Bool = false

var player1ScoreLabel: SKLabelNode!

var player1score: Int = 0 {
    didSet {
        player1ScoreLabel.text = "\(player1score)"
    }
}
var player2ScoreLabel: SKLabelNode!

var player2score: Int = 0 {
    didSet {
    player2ScoreLabel.text = "\(player2score)"
    }
}

var randomNegative = CGFloat()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory   : UInt32 = 0x1 << 1
    let BottomCategory : UInt32 = 0x1 << 4
//    let BlockCategory  : UInt32 = 0x1 << 6
    let Paddle1Category : UInt32 = 0x1 << 3
    let Paddle2Category : UInt32 = 0x1 << 2
    let TopCategory : UInt32 = 0x1 << 5

    override func didMoveToView(view: SKView) {
        //cage the ball
        super.didMoveToView(view)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVectorMake(0,0)
        
        physicsWorld.contactDelegate = self
        
        
        //load background
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: size.self.height/2)
        background.zPosition = -2
        self.addChild(background)
        
        
        //load players
        
        player1.setScale(1)
        player1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.05)
        player1.zPosition = 1
        player1.physicsBody = SKPhysicsBody(texture: player1HitBox.texture!, size: player1HitBox.size)
        player1.physicsBody!.friction = 0
        player1.physicsBody!.restitution = 0
        player1.physicsBody!.linearDamping = 0
        player1.physicsBody!.angularDamping = 0
        player1.physicsBody!.dynamic = false
        player1.physicsBody?.usesPreciseCollisionDetection = true
        player1.physicsBody?.categoryBitMask = Paddle1Category
        player1.physicsBody?.collisionBitMask = Paddle1Category | BallCategory
        player1.physicsBody?.contactTestBitMask = Paddle1Category | BallCategory
     
        self.addChild(player1)
        
        player2.setScale(1)
        player2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        player2.zPosition = 1
        player2.physicsBody = SKPhysicsBody(texture: player2HitBox.texture!, size: player2HitBox.size)
        player2.physicsBody!.friction = 0
        player2.physicsBody!.restitution = 0
        player2.physicsBody!.linearDamping = 0
        player2.physicsBody!.angularDamping = 0
        player2.physicsBody!.dynamic = false
        player2.physicsBody?.usesPreciseCollisionDetection = true
        player2.physicsBody?.categoryBitMask = Paddle2Category
        player2.physicsBody?.collisionBitMask = Paddle2Category | BallCategory
        player2.physicsBody?.contactTestBitMask = Paddle2Category | BallCategory

        
        self.addChild(player2)
        
        //load player touch control boxes
        player1SwipeBox.setScale(4)
        player1SwipeBox.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.05)
        player1SwipeBox.zPosition = -3

        self.addChild(player1SwipeBox)
        
        player2SwipeBox.setScale(4)
        player2SwipeBox.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        player2SwipeBox.zPosition = -3

        self.addChild(player2SwipeBox)
        
        
        //load goals
        goal1.setScale(1)
        goal1.position = CGPoint(x: self.size.width/2, y: (self.size.height * 0.0) + 21)
        goal1.zPosition = 0
        goal1.physicsBody = SKPhysicsBody(texture: goal1.texture!, size: goal1.size)
        goal1.physicsBody!.dynamic = false
        goal1.physicsBody?.usesPreciseCollisionDetection = true
        goal1.physicsBody?.categoryBitMask = BottomCategory
        goal1.physicsBody?.collisionBitMask = BottomCategory | BallCategory
        goal1.physicsBody?.contactTestBitMask = BottomCategory | BallCategory
        self.addChild(goal1)
        
        goal2.setScale(1)
        goal2.position = CGPoint(x: self.size.width/2, y: self.size.height - 22)
        goal2.zPosition = 0
        goal2.physicsBody = SKPhysicsBody(texture: goal2.texture!, size: goal2.size)
        goal2.physicsBody!.dynamic = false
        goal2.physicsBody?.usesPreciseCollisionDetection = true
        goal2.physicsBody?.categoryBitMask = TopCategory
        goal2.physicsBody?.collisionBitMask = TopCategory | BallCategory
        goal2.physicsBody?.contactTestBitMask = TopCategory | BallCategory
        self.addChild(goal2)

        border1.setScale(1)
        border1.position = CGPoint(x: self.size.width/2, y: (self.size.height * 0.0) + 31)
        border1.zPosition = -1
        border1.physicsBody = SKPhysicsBody(texture: border1.texture!, size: border1.size)
        border1.physicsBody!.dynamic = false
        self.addChild(border1)
        
        border2.setScale(1)
        border2.position = CGPoint(x: self.size.width/2, y: (self.size.height) - 31)
        border2.zPosition = -1
        border2.physicsBody = SKPhysicsBody(texture: border2.texture!, size: border2.size)
        border2.physicsBody!.dynamic = false
        self.addChild(border2)
        
        
        //load ball random to player 1
        let randomSpawnX = arc4random_uniform(1020) + 60
        
        let random1 = Float(arc4random_uniform(2))
        if random1 >= 1 {
            randomNegative = 1
        } else if random1 <= 0.9 {
            
            randomNegative = -1
        }
        
        ball.setScale(1.3)
        ball.position = CGPoint(x: CGFloat(randomSpawnX), y: self.size.height/2)
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0.005
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
        ball.physicsBody!.dynamic = true
        //ball.physicsBody?.veloci
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = BallCategory
        self.addChild(ball)
        ball.physicsBody!.applyImpulse(CGVectorMake( 20, -100 * randomNegative))
        
        //load buttons

        pauseButton.setScale(0.5)
        pauseButton.position = CGPoint(x: self.size.width/2 - 5, y: size.self.height/2)
        pauseButton.zPosition = 3
        pauseButton.hidden = true
        self.addChild(pauseButton)
        
        playButton.setScale(0.7)
        playButton.position = CGPoint(x: (self.size.width/2) - 5, y: size.self.height/2)
        playButton.zPosition = 3
        playButton.hidden = false
        
        self.addChild(playButton)
        
        exitButton.setScale(1)
        exitButton.position = CGPoint(x: (self.size.width/2) - 300, y: size.self.height/2)
        exitButton.zPosition = 3
        exitButton.hidden = true
        self.addChild(exitButton)
        
        resetButton.setScale(1.5)
        resetButton.position = CGPoint(x: (self.size.width/2) + 290, y: size.self.height/2)
        resetButton.zPosition = 3
        resetButton.hidden = true
        self.addChild(resetButton)
        
        
        //recognize taps to add velocity to ball
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tap(_:)))
        view.addGestureRecognizer(tap)

        //start message
        
        
        //score labels
        
        player1ScoreLabel = SKLabelNode(fontNamed: "Copperplate")
        player1ScoreLabel.setScale(-10)
        player1ScoreLabel.text = "\(player2score)"
        player1ScoreLabel.position = CGPoint(x: (self.size.width/2) + 10, y: size.self.height * 0.7)
        addChild(player1ScoreLabel)
        
        player2ScoreLabel = SKLabelNode(fontNamed: "Copperplate")
        player2ScoreLabel.setScale(10)
        player2ScoreLabel.text = "\(player1score)"
        player2ScoreLabel.position = CGPoint(x: (self.size.width/2) - 10, y: size.self.height * 0.3)
        addChild(player2ScoreLabel)
        
        
        //Winner labels
        
        
        player1WinsLabel = SKLabelNode(fontNamed: "Copperplate")
        player1WinsLabel.setScale(-3)
        player1WinsLabel.text = "YOU LOSE!!!"
        player1WinsLabel.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.7)
        player1WinsLabel.hidden = true
        addChild(player1WinsLabel)
        
        player2WinsLabel = SKLabelNode(fontNamed: "Copperplate")
        player2WinsLabel.setScale(-3)
        player2WinsLabel.text = "YOU WIN!!!"
        player2WinsLabel.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.7)
        player2WinsLabel.hidden = true
        addChild(player2WinsLabel)
        
        
        player1WinsLabel2 = SKLabelNode(fontNamed: "Copperplate")
        player1WinsLabel2.setScale(3)
        player1WinsLabel2.text = "YOU WIN!!!"
        player1WinsLabel2.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.3)
        player1WinsLabel2.hidden = true
        addChild(player1WinsLabel2)
        
        
        player2WinsLabel2 = SKLabelNode(fontNamed: "Copperplate")
        player2WinsLabel2.setScale(3)
        player2WinsLabel2.text = "YOU LOSE!!!"
        player2WinsLabel2.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.3)
        player2WinsLabel2.hidden = true
        addChild(player2WinsLabel2)
        
        //ready buttons
        
        readyButton1.setScale(1)
        readyButton1.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.2)
        readyButton1.zPosition = 3
        readyButton1.hidden = true
        self.addChild(readyButton1)
        
        readyButton2.setScale(-1)
        readyButton2.position = CGPoint(x: (self.size.width/2), y: size.self.height * 0.8)
        readyButton2.zPosition = 3
        readyButton2.hidden = true
        self.addChild(readyButton2)

        paused = true
    }

    
    override func touchesBegan(touches:Set<UITouch>, withEvent event: UIEvent?){
        //start of touch point of first touch for bars
        
        if let touch = touches.first{
            let location = touch.locationInNode(self)
            if player1SwipeBox.containsPoint(location){
                player1.position = CGPoint(x: location.x, y: frame.height * 0.05)
                player1SwipeBox.position = (CGPoint(x: location.x, y: frame.height * 0.05))
                player1.runAction(swipeHit)

            }
            else if player2SwipeBox.containsPoint(location){
                player2.position = CGPoint(x: location.x, y: frame.height * 0.95)
                player2SwipeBox.position = CGPoint(x: location.x, y: frame.height * 0.95)
                player2.runAction(swipeHit)

            }
        }
        
        

    }
    override func touchesMoved(touches:Set<UITouch>, withEvent event: UIEvent?){
        //during touch reset location of bars
        for touch in touches{
            let location = touch.locationInNode(self)
    
            if player1SwipeBox.containsPoint(location){
                player1.position = CGPoint(x: location.x, y: frame.height * 0.05)
                player1SwipeBox.position = (CGPoint(x: location.x, y: frame.height * 0.05))
                //player1HitBox.position = (CGPoint(x: location.x, y: frame.height * 0.05))

            }
            else if player2SwipeBox.containsPoint(location){
                
                player2.position = CGPoint(x: location.x, y: frame.height * 0.95)
                player2SwipeBox.position = CGPoint(x: location.x, y: frame.height * 0.95)
                //player2HitBox.position = CGPoint(x: location.x, y: frame.height * 0.95)
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        //when touch has ended
    }

    func tap(sender:UITapGestureRecognizer){
        
        
        var tapLocation: CGPoint = sender.locationInView(sender.view)
        tapLocation = self.convertPointFromView(tapLocation)
 
  
        //pause button tap

        if playButton.hidden == false && playButton.containsPoint(tapLocation) {
            
            paused = false
            pauseButton.hidden = false
            playButton.hidden = true
            resetButton.hidden = true
            exitButton.hidden = true

            print("Play")
        }
        
        if  pauseButton.hidden == false && pauseButton.containsPoint(tapLocation) && playButton.containsPoint(tapLocation) {
            paused = true
            pauseButton.hidden = true
            playButton.hidden = false
            resetButton.hidden = false
            exitButton.hidden = false
            
            print("PAWS")
        }
        
        if exitButton.containsPoint(tapLocation) && exitButton.hidden == false {
            print("exit")
            exit(0)
            
        }
        
        if readyButton1.containsPoint(tapLocation) && readyButton1.hidden == false {
            
            pauseButton.hidden = true
            playButton.hidden = true
            resetButton.hidden = true
            print("Ready1")
        }
        
        if readyButton2.containsPoint(tapLocation) && readyButton2.hidden == false {
            
            pauseButton.hidden = true
            playButton.hidden = true
            resetButton.hidden = true
            print("Ready2")
        }
        
        if resetButton.containsPoint(tapLocation) && resetButton.hidden == false {
            self.removeAllChildren()
            let gameScene = GameScene(size: self.size)
            let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            //playButton.hidden = false
            player1score = 0
            player2score = 0
            paused = true
        }
        
        
        if player1SwipeBox.containsPoint(tapLocation) {
            print("POW")
            driveHit1 = true
            let pullBack = SKAction.moveToY(((frame.height * 0.05) - 70), duration: 0.1)
            let springForward = SKAction.moveToY(((frame.height * 0.05) + 60), duration: 0.1)
            let reset = SKAction.moveToY(frame.height * 0.05, duration: 0.1)
            let swipeHit = SKAction.sequence([pullBack, springForward, reset])
            
            player1.runAction(swipeHit)
            
            //time delay for ending drive speed
            let seconds = 0.2
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                driveHit1 = false
                
            })
            
        }else if player2SwipeBox.containsPoint(tapLocation) {
            print("WHACK")
            driveHit2 = true
            let pullBack = SKAction.moveToY(((frame.height * 0.95) + 70), duration: 0.1)
            let springForward = SKAction.moveToY(((frame.height * 0.95) - 60), duration: 0.1)
            let reset = SKAction.moveToY(frame.height * 0.95, duration: 0.1)
            let swipeHit = SKAction.sequence([pullBack, springForward, reset])
           
            player2.runAction(swipeHit)
            
            //time delay for ending drive speed
            let seconds = 0.2
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                driveHit2 = false
            })
        }
        

    }
    
    

    
    func didBeginContact(contact: SKPhysicsContact) {

        //add velocity on drive hit
        if driveHit1 == true && (contact.bodyA.categoryBitMask == Paddle1Category) && (contact.bodyB.categoryBitMask == BallCategory) || driveHit1 == true &&
            (contact.bodyB.categoryBitMask == Paddle1Category) && (contact.bodyA.categoryBitMask == BallCategory)
        {
                print("Hit1")
                ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 120))

            
        }else if driveHit2 == true && (contact.bodyA.categoryBitMask == Paddle2Category) && (contact.bodyB.categoryBitMask == BallCategory) || driveHit2 == true && (contact.bodyB.categoryBitMask == Paddle2Category) && (contact.bodyA.categoryBitMask == BallCategory)
        {
                print("Hit2")
                ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -120))

        }
        
        //detect goal hit
        if (contact.bodyA.categoryBitMask == BottomCategory) && (contact.bodyB.categoryBitMask == BallCategory) ||
            (contact.bodyB.categoryBitMask == BottomCategory) && (contact.bodyA.categoryBitMask == BallCategory)
        {
            print("Player2 Scored!")
            player1score += 1
            
            
        }else if (contact.bodyA.categoryBitMask == TopCategory) && (contact.bodyB.categoryBitMask == BallCategory) || (contact.bodyB.categoryBitMask == TopCategory) && (contact.bodyA.categoryBitMask == BallCategory)
        {
            print("Player1 Scored!")
            player2score += 1
            
        }
        
        checkgameOver()

    }
    
    func checkgameOver(){
        
        //show menu buttons and explode the ball and display winning and losing side
        if player1score >= 3
        {
            print("Player 2 WINS!!!")
            player1ScoreLabel.hidden = true
            player2ScoreLabel.hidden = true
            pauseButton.hidden = true
            resetButton.hidden = false
            player2WinsLabel.hidden = false
            player2WinsLabel2.hidden = false
            
            
            let particles = SKEmitterNode(fileNamed: "ballExplosion")!
            
            particles.position = convertPoint(CGPoint( x:0, y:0), fromNode: ball)
            particles.zPosition = 3
            particles.numParticlesToEmit = 15
            
            
            addChild(particles)
            ball.removeFromParent()
        }
        else if player2score >= 3
        {
            print("Player 1 WINS!!!")
            player1ScoreLabel.hidden = true
            player2ScoreLabel.hidden = true
            pauseButton.hidden = true
            resetButton.hidden = false
            player1WinsLabel.hidden = false
            player1WinsLabel2.hidden = false
            
            let particles = SKEmitterNode(fileNamed: "ballExplosion")!
            
            particles.position = convertPoint(CGPoint( x:0, y:0), fromNode: ball)
            particles.zPosition = 3

            particles.numParticlesToEmit = 15
            
            
            addChild(particles)
            ball.removeFromParent()
        }
    }
    
    
}

