//
//  Slot.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-04-01.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import GameplayKit
import SpriteKit

public struct ReelInfo {
    var stepSymbolsInReel: [Int]
    var stepIndex: Int
    var stepSpinTotal: Int                 // Number of repetetions for each spinDuration
}

public struct ReelSpinInfo {
    var stepIndex: Int
    var stepIndexMoveBy: Int
    var stepSpinTotal: Int
    var actionSequence: [SKAction]
}

class Slot {
    
    var reelSpinInfos = [ReelSpinInfo]()
    var stepSymbolSize: CGSize?
    var isSpinning: Bool?
    var reelSpinInfo: [ReelSpinInfo]?

    var randomSource:GKRandomSource?
    var scene: GameScene?
    
    let stepSymbolCount: Int!

    init(scene: GameScene) {
        
        self.scene = scene
        self.isSpinning = false
        
        stepSymbolCount = stepSymbol.count
        
        // Save the size of the step symbol
        // TODO: Replace with the actual image's width and height
        stepSymbolSize = CGSize(width: 100.0, height: 120.0)
        print("Height: \(self.stepSymbolSize?.height)")
     
        // Setup the initial image rendered for the reel
        self.resetReels()
        
        // Setup random source
        self.randomSource = GKARC4RandomSource()
    }
    
    // Reset the reels based on the position of the step count
    public func resetReels() {
        
        self.reelSpinInfos.removeAll()
        
        // Populate the reels
        for index in 0..<reelInfos.count {
            self.reelSpinInfos.append(ReelSpinInfo(stepIndex: reelInfos[index].stepIndex,
                                                   stepIndexMoveBy: 0,
                                                   stepSpinTotal: reelInfos[index].stepIndex,
                                                   actionSequence: []))
        }
        
        // Initialize the position of the steps in all reels
        self.spinReels(stepSpinDuration: 0.0)
    }
    
    // Spin the slot machine reels
    public func spinReels() {
        
        // Setup the number of steps to be spinned per reel
        for index in 0..<reelInfos.count {
            let randomNumber = randomSource?.nextInt(upperBound: stepSymbolCount)
            self.reelSpinInfos[index].stepSpinTotal = randomNumber! + reelInfos[index].stepSpinTotal
            print("Reel \(index) random number: \(randomNumber), Total steps: \(self.reelSpinInfos[index].stepSpinTotal)")
        }
        
        self.spinReels(spinReels(stepSpinDuration: 0.0))
    }
    
    // Spin the reels
    private func spinReels(stepSpinDuration: Double) {
        
        // Setup the sequence of spin actions generated for each reel
        for index in 0..<self.reelSpinInfos.count {
            self.reelSpinInfos[index].actionSequence.removeAll();
            self.reelActionSeqeuence(reel: index, stepSpinDuration: stepSpinDuration)
        }
        
        // Spin each reel 
        for index in 0..<self.reelSpinInfos.count - 1 {
            scene?.reels[index].reel?.run(SKAction.sequence(self.reelSpinInfos[index].actionSequence))
        }
        
        // Setup complete action upon completion of the last spinned reel
        let lastReel = reelSpinInfos.count - 1
        scene?.reels[lastReel].reel?.run(SKAction.sequence(self.reelSpinInfos[lastReel].actionSequence), completion: {
            self.isSpinning = false
        })
    }

    // Setup the sequence of actions generated for each reel
    private func reelActionSeqeuence(reel: Int, stepSpinDuration: Double) {

        var stepIndex = self.reelSpinInfos[reel].stepIndex
        var stepScrollCount:Int!
        let stepHeight = (self.stepSymbolSize?.height)! + stepSymbolGap
        
        repeat {
            
            // Setup the number of steps to be scrolled
            stepScrollCount = self.stepSymbolCount - stepIndex
            
            // Add the appropriate spin action
            if (self.reelSpinInfos[reel].stepSpinTotal <= self.stepSymbolCount) {
                
                //
                // Last spin action
                //
                stepScrollCount = self.reelSpinInfos[reel].stepSpinTotal
                let deltaY = CGFloat(stepScrollCount) * -stepHeight
                print("Scroll Count: \(stepScrollCount), Height: \(-stepHeight), Delta Y: \(deltaY)")
                let delta = CGVector(dx: 0, dy: deltaY)
                let spinMoveBy = SKAction.move(by: delta,
                                               duration: Double(stepScrollCount) * stepSpinDuration)
                self.reelSpinInfos[reel].actionSequence.append(spinMoveBy)
                
                // Save the new step index of the reel
                self.reelSpinInfos[reel].stepIndex = stepScrollCount % self.stepSymbolCount
            } else {
                
                // 
                // First and succeeding spin actions 
                //

                let spinMoveTo = SKAction.moveTo(y: CGFloat(self.stepSymbolCount) * -stepHeight,
                                                 duration: Double(stepScrollCount) * stepSpinDuration)
                
                self.reelSpinInfos[reel].actionSequence.append(spinMoveTo)
            }
            
            // Reset back to the first step
            if stepScrollCount == self.stepSymbolCount {
                let reset = SKAction.moveTo(y: 0, duration: 0)
                self.reelSpinInfos[reel].actionSequence.append(reset)
            }
            
            // Move to the next set of steps to be spinned
            stepIndex = 0
            self.reelSpinInfos[reel].stepSpinTotal -= stepScrollCount

        } while self.reelSpinInfos[reel].stepSpinTotal > 0
        
    }
    
    private func lastSpinAction() {
        
    }
    
    private func notLastSpinAction() {
        
    }
}
