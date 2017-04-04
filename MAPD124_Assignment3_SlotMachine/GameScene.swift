//
//  GameScene.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-25.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import UIKit

var width:CGFloat?
var height:CGFloat?

class GameScene: SKScene, CustomButtonDelegate, BetButtonDelegate {

    var slot:Slot?
    var reels:[Reel] = []
    var spinningSound: SKAudioNode?
    var jackpot: SKSpriteNode?
    
    // Cash-related labels
    var balanceLabel: UILabel?
    var wonLabel: UILabel?
    var jackpotLabel: UILabel?
    var totalBetLabel: UILabel?
    
    override func didMove(to view: SKView) {
    
        // Save the size
        let screenSize = UIScreen.main.bounds
        width = screenSize.width
        height = screenSize.height
        
        // Add jackpot
        let sprite = SKSpriteNode(imageNamed: "Jackpot")
        sprite.zPosition = -3
        sprite.position = CGPoint(x: 0.0, y: 0.2342 * height!)
        self.addChild(sprite)
        self.jackpot = sprite
        
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
        
        // Add the reels
        self.setupReels()
        
        // Add bet buttons
        self.setupButtons()
        
        if self.slot == nil {
            self.slot = Slot(scene: self)
            
            // Update the cash labels
            self.slot?.updateAllCash()
        }
        
        // Preload the sounds
        self.preloadSounds()

        // Setup sounds
        let spinningSound1 = SKAudioNode(fileNamed: "spinning.wav")
        self.spinningSound = spinningSound1
        self.addChild(spinningSound1)
        self.spinningSound?.run(SKAction.stop())
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
    
    // Preload the sounds
    private func preloadSounds() {
        
        do {
            let sounds: [String] = ["spinning", "win", "jinglewin"]
            for sound in sounds {
                let path: String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url: URL = URL(fileURLWithPath: path)
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            }
        } catch {
            print("Audio file not found!")
        }
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
        // Set the Bet button delegates
        betPlus.name = "betPlus"
        betPlus.delegate = self

        
        let betMinus = BetButton(imageName: "BetPlusMinus",
                                 at: CGPoint(x: 0 - betPlus.size.width,
                                             y: betHeight),
                                 topName: "Bet", bottomName: "-")
        betMinus.name = "betMinus"
        betMinus.delegate = self

        let betMax = BetButton(imageName: "BetMax",
                               at: CGPoint(x: betPlus.size.width,
                                           y: betHeight),
                               topName: "Bet", bottomName: "Max")
        betMax.name = "betMax"
        betMax.delegate = self
        
        self.addChild(betPlus)
        self.addChild(betMinus)
        self.addChild(betMax)
        
        // Setup the Spin button
        // x = 270, y = -420
        let playButton = CustomButton(imageName: ["SpinButtonRelease", "SpinButtonPress"],
                                       at: CGPoint(x: 0.3490 * width!,
                                                   y: -0.4238 * height!))
        playButton.delegate = self
        self.addChild(playButton)
    }
    
    // Configure the reels of the slot machine
    private func setupReels() {
        let images:[String] = ["Reel1", "Reel1", "Reel1"]
        
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
    
    // Custom Button Handler
    public func buttonPressed() {
    }
    
    public func buttonReleased() {
        if (!(self.slot?.isSpinning)!) {
            slot?.spinReels()
        }
    }
    
    
    // Spin reel handler
//    public func spinReels() {
////        slot?.spinReels()
//    }
    
    // Bet button handler
    func betButtonPressed(name: String) {
        if (name == "betPlus") {
            self.slot?.increaseBet()
        } else if (name == "betMinus"){
            self.slot?.decreaseBet()
        } else if (name == "betMax"){
            self.slot?.maxBet()
        }
    }

}
