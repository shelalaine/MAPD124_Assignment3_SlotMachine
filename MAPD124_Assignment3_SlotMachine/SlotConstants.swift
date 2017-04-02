//
//  SlotConstants.swift
//  MAPD124_Assignment3_SlotMachine
//
//  Created by Shelalaine Chan on 2017-04-01.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import GameplayKit

//public struct Win {
//    var payline: String
//    var combo: [Int]
//}


// Symbol information for the reels
// Payline: Middle
//  3 diamonds = 100
//  3 sevens = 75
//  3 bells = 50
//  3 cherries = 45
//  3 watermelons = 30
//  3 bananas = 20
//  3 apples = 15
//  3 lemons = 10
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
//        stepIndex: 1,
        stepIndex: 3,
        stepSpinTotal: 40   // 1 second
    ),
    ReelInfo(
//        stepSymbolsInReel: [2, 6, 4, 5, 7, 3, 1, 0],
        stepSymbolsInReel: [0, 1, 2, 3, 4, 5, 6, 7],
//        stepIndex: 7,
        stepIndex: 3,
        stepSpinTotal: 80   // 2 seconds
    ),
    ReelInfo(
//        stepSymbolsInReel: [4, 7, 5, 1, 6, 2, 0, 3],
        stepSymbolsInReel: [0, 1, 2, 3, 4, 5, 6, 7],
//        stepIndex: 4,
        stepIndex: 3,
        stepSpinTotal: 120   // 3 seconds
    ),
]


class SlotConstants {

}
