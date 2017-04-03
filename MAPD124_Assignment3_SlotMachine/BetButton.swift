//
//  BetButton.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-28.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit

protocol BetButtonDelegate: class {
    func betButtonPressed(name: String)
}

class BetButton: SKSpriteNode {
    
    weak var delegate:BetButtonDelegate?

    init(imageName: String,
         at position: CGPoint,
         topName:String,
         bottomName: String) {
        
        // TODO: Replace hard-coding of the image size
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 97, height: 94))
        self.zPosition = 2
        self.position = position
        
        // Configure label 1
        let betLabel = SKLabelNode(text: topName)
        betLabel.fontName = "Chalkduster"
        betLabel.fontSize = 32
        betLabel.zPosition = self.zPosition + 1
        self.addChild(betLabel)

        // Configure label 2
        let betLabel2 = SKLabelNode(text: bottomName)
        betLabel2.position.y = -30.0
        betLabel2.fontSize = 28
        betLabel2.fontName = "Helvetica Neue Condensed Bold"
        betLabel2.zPosition = self.zPosition + 1
        self.addChild(betLabel2)

        // Allow user interaction
        self.isUserInteractionEnabled = true
        
        print("Buttons: \(self.size.width), \(self.size.width)")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil {
            delegate?.betButtonPressed(name: self.name!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
