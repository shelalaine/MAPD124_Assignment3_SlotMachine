//
//  File Name:      Reel.swift
//  Project Name:   MAPD124-Assignment3
//  Description:    Custom button object used in the slot machine game
//                  Most of the images used in this project are downloaded and credited from www.freepik.com
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-03-27, Created
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

import SpriteKit
import CoreGraphics

protocol CustomButtonDelegate: class {
    func buttonPressed()
    func buttonReleased()
}

class CustomButton: SKSpriteNode {
    
    var textureAtlas: SKTextureAtlas?
    weak var delegate:CustomButtonDelegate?
    
    init(imageName: [String],
         at position: CGPoint) {
        
        // TODO: Replace hard-coding of the image size
        super.init(texture: SKTexture(imageNamed: imageName[0]),
                                   color: UIColor.clear,
                                   size: CGSize(width: 150, height: 150))
        self.position = position
        self.isUserInteractionEnabled = true

        // Save images to memory to speed up image rendering
        guard let press = UIImage(named: imageName[1]),
            let release = UIImage(named: imageName[0]) else {
                return
        }
        textureAtlas = SKTextureAtlas(dictionary: [
            "release": release,
            "press": press])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonPressed()
        if delegate != nil {
            delegate?.buttonPressed()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonReleased()
        if delegate != nil {
            delegate?.buttonReleased()
        }
    }
    
    public func buttonPressed() {
        self.texture = textureAtlas?.textureNamed("press")
    }
    
    public func buttonReleased() {
        self.texture = textureAtlas?.textureNamed("release")
    }
    
}

