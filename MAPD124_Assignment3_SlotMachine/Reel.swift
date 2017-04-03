//
//  Reel.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-25.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit

class Reel: SKNode {

    var reel:SKSpriteNode?

    func configure(imageName: String, at position: CGPoint) {
        let anchor = CGPoint(x: 0.5, y: 0.0)
        
        // Save the position
//        self.position = position
        
        // Setup the mask
        let cropNode = SKCropNode()
        cropNode.position = position
        cropNode.zPosition = 1
        let texture = SKTexture(imageNamed: "ReelMask")
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: 100.0, height: 390.0))
        sprite.anchorPoint = anchor
        cropNode.maskNode = sprite
        
        // Add the image of this reel
        reel = SKSpriteNode(imageNamed: imageName)
//        reel?.position = CGPoint(x: 0.0, y: 0.0)
        reel?.anchorPoint = anchor
        reel?.name = "reel"
        cropNode.addChild(reel!)
        
        addChild(cropNode)
        print("x: \(position.x) y: \(position.y)")
        
    }
}
