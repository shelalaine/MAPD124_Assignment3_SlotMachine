//
//  CustomButton.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-03-27.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

import SpriteKit
import CoreGraphics

protocol CustomButtonDelegate: class {
    func spinReels()
}

class CustomButton: SKNode {
    
    var imageSprite: SKSpriteNode?
    var xPosReleased:CGFloat?
    var xPosPressed:CGFloat?
    var isSpinning:Bool?
    weak var delegate:CustomButtonDelegate?
    
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
            xPosPressed = position.x + (sprite.size.width / 2) + 1
            xPosReleased = (position.x - (sprite.size.width / 2))
            print("\(xPosReleased!) \(position.x) \(xPosPressed!)")
            
            imageSprite = SKSpriteNode(imageNamed: "Button")
            imageSprite?.position = CGPoint(x: xPosReleased!, y: position.y)
            
            cropNode.addChild(imageSprite!)
            self.addChild(cropNode)
            
            self.isSpinning = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonPressed()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonReleased()
        if delegate != nil {
            if self.isSpinning == false {
                delegate?.spinReels()
            }
        }
    }
    
    public func buttonPressed() {
        self.imageSprite?.position.x = xPosPressed!
    }
    
    public func buttonReleased() {
        self.imageSprite?.position.x = xPosReleased!
    }
    
}

