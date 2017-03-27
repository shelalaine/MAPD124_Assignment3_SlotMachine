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

class GameScene: SKScene {
    
    var reels:[Reel] = []
    
    override func didMove(to view: SKView) {
        let screenSize = UIScreen.main.bounds
        width = screenSize.width
        height = screenSize.height
        

//        view.showsPhysics = true
        
        let images:[String] = ["Reel1", "Reel2", "Reel3"]
        
        for i in 0..<images.count {
            reels.append(Reel())
             
            var adjust = (i - 1 <= 0) ? -10 : 10
            if i - 1 == 0 {
                adjust = 0
            }
            
            reels[i].configure(imageName: images[i],
                               at: CGPoint(x: (Double(i - 1) * 100.0) + Double(adjust), y: 0.0))
            self.addChild(reels[i])
        }
        
        spinReels()
        
        let buttonPlay = Button()
        buttonPlay.configure(at: CGPoint(x: 0.0, y: -0.5 * height!))
        self.addChild(buttonPlay)
    }
    
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
        
        self.reels[0].reel?.run(SKAction.repeat(sequence, count: 20))
    }

    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spinReels()
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
}
