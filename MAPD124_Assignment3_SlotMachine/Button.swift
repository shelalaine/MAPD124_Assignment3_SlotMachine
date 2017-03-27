//
//  Button.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-27.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import SpriteKit
import CoreGraphics

class Button: SKNode {
    
    var imageSprite: SKSpriteNode?
    var xPosReleased:CGFloat?
    var xPosPressed:CGFloat?
    
    override init() {
        super.init()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at position: CGPoint) {
        if (imageSprite == nil) {
            
            // Setup the mask
            let cropNode = SKCropNode()
            cropNode.zPosition = 1
            let sprite = SKSpriteNode(imageNamed: "ButtonMask")
            sprite.position = position
            cropNode.maskNode = sprite

            // Setup the released and pressed x positions
            xPosPressed = (sprite.size.width / 2) + 1
            xPosReleased = (0 - (sprite.size.width / 2))
            print("\(xPosReleased!) \(position.x) \(xPosPressed!)")
            
            imageSprite = SKSpriteNode(imageNamed: "Button")
            imageSprite?.position = CGPoint(x: xPosReleased!, y: position.y)
            cropNode.addChild(imageSprite!)
            self.addChild(cropNode)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.imageSprite?.position.x = xPosPressed!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.imageSprite?.position.x = xPosReleased!
    }
}
