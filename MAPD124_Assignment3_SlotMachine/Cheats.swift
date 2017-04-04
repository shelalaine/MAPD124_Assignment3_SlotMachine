//
//  Cheats.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-04-04.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit

class Cheats {
    var scene: GameScene?
    var cheatButton: CustomButton?
    var cheatButtonPressCount: Int?
    let GENERATE_JACKPOT_BUTTON_COUNT = 7
    
    init(scene: GameScene) {
        self.scene = scene
        
        self.cheatReset()
        
        // Add a button in the top right-corner of the screen
//        let texture = SKTexture(imageNamed: "ReelMask")

        // x = ((768 / 2) - 50) / 768
        // y = (1024 / 2) - 50) / 1024
        let position = CGPoint(x: 0.4349 * 768, y: 0.4512 * 1024)
        
        self.cheatButton = CustomButton(imageName: ["50x50transparent", "50x50transparent"],
                                        at: position)
        self.cheatButton?.size = CGSize(width: 50.0, height: 50.0)
        self.cheatButton?.anchorPoint = CGPoint(x: 0, y: 0)
        self.cheatButton?.name = "Cheat"
        self.cheatButton?.zPosition = 1
        self.cheatButton?.delegate = self.scene!
        self.scene?.addChild(self.cheatButton!)
        
    }
    
    public func cheatButtonEvent() {
        self.cheatButtonPressCount = self.cheatButtonPressCount! + 1
        print("Cheat Button Pressed: \(self.cheatButtonPressCount!)")
    }
    
    public func cheatReset() {
        self.cheatButtonPressCount = 0
        print("Cheat Button Reset: \(self.cheatButtonPressCount!)")
    }
    
    public func shouldGenereJackpot() -> Bool {
        return self.cheatButtonPressCount == GENERATE_JACKPOT_BUTTON_COUNT ? true : false
    }
}
