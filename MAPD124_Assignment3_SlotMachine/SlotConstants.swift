//
//  SlotConstants.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-04-01.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import GameplayKit

// Symbol information for the reels
let stepSymbol: Dictionary<Int, String> = [
    0: "seven",
    1: "watermelon",
    2: "cherry",
    3: "banana",
    4: "diamond",
    5: "lemon",
    6: "bell",
    7: "apple"
]

// Spin information
// Scroll duration / symbol
public let stepScrollDuration = 0.025

// Reel information
public let reelCount = 3
public let stepSymbolShown = 3
public let stepSymbolGap: CGFloat = 10.0
public let reelInfos: [ReelInfo] = [
    ReelInfo(
        stepSymbolsInReel: [0, 1, 2, 3, 4, 5, 6, 7],
        stepIndex: 1,
        stepSpinTotal: 40
    ),
    ReelInfo(
        stepSymbolsInReel: [2, 6, 4, 3, 4, 5, 1, 0],
        stepIndex: 7,
        stepSpinTotal: 60
    ),
    ReelInfo(
        stepSymbolsInReel: [4, 7, 5, 1, 6, 2, 0, 3],
        stepIndex: 4,
        stepSpinTotal: 80
    ),
]

class SlotConstants {

}
