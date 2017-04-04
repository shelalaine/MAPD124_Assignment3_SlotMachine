//
//
//  File Name:      Slot.swift
//  Project Name:   MAPD124-Assignment3
//  Description:    Slot Controller/Manager
//                  Most of the images used in this project are downloaded and credited from www.freepik.com
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-04-01, Created
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import GameplayKit
import SpriteKit
import AVFoundation

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
    
    // Cash stuff
    private var totalCash: Double?
    private var totalBet: Int?
    private var won: Int?
    private var jackpot: Double?
    private var betIncrementIndex: Int?

    private var reelSpinInfos = [ReelSpinInfo]()
    private var stepSymbolSize: CGSize?
    var isSpinning: Bool?

    var randomSource:GKRandomSource?
    var scene: GameScene?

    
    let stepSymbolCount: Int!

    init(scene: GameScene) {
        
        self.scene = scene
        self.isSpinning = false
        
        // Save the size of the step symbol
        // TODO: Replace with the actual image's width and height
        stepSymbolSize = CGSize(width: 100.0, height: 120.0)
        print("Height: \(self.stepSymbolSize?.height)")
     
        stepSymbolCount = stepSymbol.count

        // Setup random source
        self.randomSource = GKARC4RandomSource()

        // Initialize the money
        self.resetMoney()
        
        // Setup the initial image rendered for the reel
        self.resetReels()

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
        
        self.spinReels(stepSpinDuration: stepScrollDuration)
        
    }
    
    
    // Spin the reels
    private func spinReels(stepSpinDuration: Double) {
        
        // Check if there is enough dough to spin
        let newBalance = self.totalCash! - Double(self.totalBet!)
        if (newBalance >= 0) {
            
            self.generateJackpot(status: false)
            
            // Deduct bet from total cash
            self.totalCash = newBalance
            self.showTotalCash()
        
            // Setup the sequence of spin actions generated for each reel
            for index in 0..<self.reelSpinInfos.count {
                self.reelSpinInfos[index].actionSequence.removeAll();
                self.reelActionSeqeuence(reel: index, stepSpinDuration: stepSpinDuration)
            }
            
            if (stepSpinDuration > 0) {
                // Play sound if necessary
                self.scene?.spinningSound?.run(SKAction.play())
            }
            
            // Spin each reel
            self.isSpinning = true
            for index in 0..<self.reelSpinInfos.count - 1 {
                scene?.reels[index].reel?.run(SKAction.sequence(self.reelSpinInfos[index].actionSequence))
            }
            
            // Setup complete action upon completion of the last spinned reel
            let lastReel = reelSpinInfos.count - 1
            scene?.reels[lastReel].reel?.run(SKAction.sequence(self.reelSpinInfos[lastReel].actionSequence), completion: {
                self.isSpinning = false
                if (stepSpinDuration > 0) {
                    self.scene?.spinningSound?.run(SKAction.stop())
                    self.spinComplete()
                }
            })
        }
    }
    
    private func spinComplete() {
        
        // Show amount won
        let winningInfo = self.checkWinnings()
        self.won = winningInfo.0
        self.showTotalWon()
        
        if (self.won! > 0) {
            
            // Update total cash
            self.totalCash = self.totalCash! + Double(self.won!)
            self.showTotalCash()
            
            // Do jackpot animation and cheer if applicable
            if (winningInfo.1) {
                generateJackpot(status: true)
            } else {
                self.scene?.run(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
            }
        }
    }
    
    // Show or hide the jackpot imate
    private func generateJackpot(status: Bool) {
        if (status) {
            self.scene?.jackpot?.zPosition = 0
            self.scene?.run(SKAction.playSoundFileNamed("jinglewin.wav", waitForCompletion: true), completion: {
                self.scene?.jackpot?.zPosition = -3
            })
        } else {
            self.scene?.jackpot?.zPosition = -3
        }
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
                
                // Reset back to the first step
                if stepScrollCount == self.stepSymbolCount {
                    let reset = SKAction.moveTo(y: 0, duration: 0)
                    self.reelSpinInfos[reel].actionSequence.append(reset)
                }
                
                // Save the new step index of the reel
                self.reelSpinInfos[reel].stepIndex = stepScrollCount % self.stepSymbolCount
            } else {
                
                // 
                // First and succeeding spin actions 
                //

                let spinMoveTo = SKAction.moveTo(y: CGFloat(self.stepSymbolCount) * -stepHeight,
                                                 duration: Double(stepScrollCount) * stepSpinDuration)
                
                self.reelSpinInfos[reel].actionSequence.append(spinMoveTo)
                
                // Reset back to the first step
                let reset = SKAction.moveTo(y: 0, duration: 0)
                self.reelSpinInfos[reel].actionSequence.append(reset)
            }
            
            // Move to the next set of steps to be spinned
            stepIndex = 0
            self.reelSpinInfos[reel].stepSpinTotal -= stepScrollCount

        } while self.reelSpinInfos[reel].stepSpinTotal > 0
        
    }
   
    // Increase bet
    public func increaseBet() {
        
        if betIncrementIndex! < (betIncrements.count - 1) {
            // Increase bet
            betIncrementIndex = betIncrementIndex! + 1
            self.showTotalBet()
        }
    }
    
    // Decrease bet
    public func decreaseBet() {
        
        if betIncrementIndex! > 0 {
            // Decrease bet
            betIncrementIndex = betIncrementIndex! - 1
            self.showTotalBet()
        }
    }
    
    // Set to the maximum possible allowable bet
    public func maxBet() {

        betIncrementIndex = (betIncrements.count - 1)
        self.showTotalBet()
    }
    
    private func showTotalBet() {
        self.totalBet = betIncrements[betIncrementIndex!]
        
        // Update the total bet
        self.scene?.totalBetLabel?.text = "$ \(self.totalBet!)"
    }
    
    public func showTotalCash() {
        let data = String((self.totalCash)!).components(separatedBy: ".")
        self.scene?.balanceLabel?.text = "$ \(data[0])"
    }
    
    public func showTotalWon() {
        let data = String((self.won)!).components(separatedBy: ".")
        self.scene?.wonLabel?.text = "$ \(data[0])"
    }
    
    // Update all cash displays
    public func updateAllCash() {
        self.showTotalCash()
        self.showTotalWon()
        
        // Show jackpot
        let data = String((self.jackpot)!).components(separatedBy: ".")
        self.scene?.jackpotLabel?.text = "$ \(data[0])"
        
        // Update the total bet
        self.scene?.totalBetLabel?.text = "$ \(self.totalBet!)"
    }
    
    // Initializes money matters
    private func resetMoney() {
        self.betIncrementIndex = 2
        self.totalBet = betIncrements[betIncrementIndex!]
        self.totalCash = 2500 + Double(self.totalBet!)
        self.won = 0
        self.jackpot = 100000
    }
    
    
    // Check if you got lucky with the spin
    private func checkWinnings() -> (Int, Bool) {
        
        var isJackpotWon = false
        var amountWon = 0
        // Index
        // 0 - bottom, 
        // 1 - middle, 
        // 2 - top, 
        // 3 - '\', 
        // 4 - '/'
        var isMatching:[Int] = [1, 1, 1, 1, 1]      // Assume all are matching
        let symbols:[Int] = self.getSymbols(for: 0, bottom: self.reelSpinInfos[0].stepIndex)
        
        // Check if all indices match
        for index in 1..<self.reelSpinInfos.count {
            
            // Get the corresponding symbols in the specified Reel
            let newSymbols = self.getSymbols(for: index, bottom: self.reelSpinInfos[index].stepIndex)
            
            // Check for a match for all payline patterns: bottom, middle, top, '\', '/'
            for i in 0..<symbols.count {
                isMatching[i] = Int(isMatching[i]) &
                    Int((symbols[i] == newSymbols[i]) ? 1 : 0)
            }
        }
        
        // Return the amount won in the bottom line
        for index in 0..<isMatching.count {
            if (isMatching[index] == 1) {
                amountWon += winnings[stepSymbol[symbols[index]]!]! * self.totalBet!
                print("Pattern \(index) won: \(winnings[stepSymbol[symbols[index]]!]! * self.totalBet!)" )
            }
        }
        
        // Check if the jackpot was won
        if isMatching[2] == 1 {
            if (stepSymbol[symbols[2]] == "diamond") {
                amountWon = amountWon + Int(self.jackpot!)
                isJackpotWon = true
            }
        }

        return (amountWon, isJackpotWon)
    }
    
    // Get the corresponding symbols in the specified Reel
    private func getSymbols(for reel: Int, bottom: Int) -> [Int]{
        var symbols:[Int] = [0, 0, 0, 0, 0]
        
        // Bottom Pattern
        symbols[0] = bottom
        
        // Middle Pattern
        symbols[1] = (bottom + 1) % self.stepSymbolCount!
        
        // Top Pattern
        symbols[2] = (bottom + 2) % self.stepSymbolCount!
        
        // '\' Diagonal Pattern
        symbols[3] = (bottom + ((reelCount - 1) - reel)) % self.stepSymbolCount!
        
        // '/' Diagonal Pattern
        symbols[4] = (bottom + reel) % self.stepSymbolCount!
        
        return symbols
    }

    
    
}
