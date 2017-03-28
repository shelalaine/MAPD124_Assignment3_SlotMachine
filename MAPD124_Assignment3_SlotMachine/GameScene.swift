//
//  GameScene.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-25.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit
import GameplayKit

var width:CGFloat?
var height:CGFloat?

class GameScene: SKScene, CustomButtonDelegate {
    
    var reels:[Reel] = []
    var playButton:CustomButton?
    
    override func didMove(to view: SKView) {
        
        // Save the size
        let screenSize = UIScreen.main.bounds
        width = screenSize.width
        height = screenSize.height
        
        // Add background
        let background = SKSpriteNode(imageNamed: "Background")
        background.zPosition = -2
        self.addChild(background)
        
        // Add reel border
        // x = 0, y = 124
        let header = SKSpriteNode(imageNamed: "ReelBorder")
        header.position = CGPoint(x: 0.0, y: 0.1211 * height!)
        header.zPosition = -1
        self.addChild(header)
        
        // Add bet buttons
        self.setupButtons()
        
        // Add the reels
        self.setupReels()
    }
    
    func touchDown(atPoint pos : CGPoint) {
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // Configure the bet and spin buttons
    private func setupButtons() {

        // Setup the Bet buttons
        // x = variable, y = -434
        let betHeight = -0.4238 * height!
        let betPlus = BetButton(imageName: "BetPlusMinus",
                                at: CGPoint(x: 0,
                                            y: betHeight),
                                topName: "Bet", bottomName: "+")
        
        let betMinus = BetButton(imageName: "BetPlusMinus",
                                 at: CGPoint(x: 0 - betPlus.size.width,
                                             y: betHeight),
                                 topName: "Bet", bottomName: "-")
        
        let betMax = BetButton(imageName: "BetMax",
                               at: CGPoint(x: betPlus.size.width,
                                           y: betHeight),
                               topName: "Bet", bottomName: "Max")
        self.addChild(betPlus)
        self.addChild(betMinus)
        self.addChild(betMax)

        // Setup the Spin button
        // x = 270, y = -420
        playButton = CustomButton()
        playButton?.delegate = self
        playButton?.configure(at: CGPoint(x: 0.3490 * width!,
                                          y: -0.4238 * height!))
        self.addChild(playButton!)
    }
    
    // Configure the reels of the slot machine
    private func setupReels() {
        let images:[String] = ["Reel1", "Reel2", "Reel3"]
        
        for i in 0..<images.count {
            reels.append(Reel())
            
            var adjust = (i - 1 <= 0) ? -10 : 10
            if i - 1 == 0 {
                adjust = 0
            }
            
            reels[i].configure(imageName: images[i],
                               at: CGPoint(x: CGFloat(i - 1) * 100.0 + CGFloat(adjust),
                                           y: -0.08 * height!))

            self.addChild(reels[i])
        }
    }
    
    // Spin reel handler
    public func spinReels() {
        let delta = CGVector(dx: 0, dy: -650)
        let spin = SKAction.move(by: delta, duration: 0.20)
        let reset = SKAction.moveTo(y: 0, duration: 0)
        let sequence = SKAction.sequence([spin, reset])
        
        //        let spinReel1 = SKAction.run {
        //            self.reels[0].reel?.run(SKAction.repeat(sequence, count: 20))
        //        }
        //        let spinReel2 = SKAction.run {
        //            self.reels[1].reel?.run(SKAction.repeat(sequence, count: 30))
        //        }
        //        let spinReel3 = SKAction.run {
        //            self.reels[2].reel?.run(SKAction.repeat(sequence, count: 40))
        //        }
        //        SKAction.group([spinReel1, spinReel2, spinReel3])
        
        self.playButton?.isSpinning = true
        
        self.reels[0].reel?.run(SKAction.repeat(sequence, count: 20))
        self.reels[1].reel?.run(SKAction.repeat(sequence, count: 30))
        self.reels[2].reel?.run(SKAction.repeat(sequence, count: 40), completion: {
            self.playButton?.isSpinning = false
        })
        
        print("Spinning status: \((self.playButton?.isSpinning)!)")
    }
}
