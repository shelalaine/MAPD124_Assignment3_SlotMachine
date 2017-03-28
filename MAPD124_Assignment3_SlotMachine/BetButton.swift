//
//  BetButton.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-28.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit

class BetButton: SKSpriteNode {
    
    init(imageName: String,
         at position: CGPoint,
         topName:String,
         bottomName: String) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
        
        // Configure label 1
        let betLabel = SKLabelNode(text: topName)
        betLabel.fontName = "Chalkduster"
        betLabel.fontSize = 32
        
        // Configure label 2
        let betLabel2 = SKLabelNode(text: bottomName)
        betLabel2.position.y = -30
        betLabel2.fontSize = 28
        betLabel2.fontName = "Helvetica Neue Condensed Bold"
        
        // Attach nodes to corresponding parents
        self.addChild(betLabel)
        self.addChild(betLabel2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
