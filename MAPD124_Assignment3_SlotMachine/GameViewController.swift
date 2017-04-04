//
//  File Name:      GameViewController.swift
//  Project Name:   MAPD124-Assignment3
//  Description:    Game View Controller
//                  Most of the images used in this project are downloaded and credited from www.freepik.com
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-03-25, Created
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var totalBetLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene{
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.balanceLabel = self.balanceLabel
                scene.wonLabel = self.wonLabel
                scene.jackpotLabel = self.jackpotLabel
                scene.totalBetLabel = self.totalBetLabel
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
