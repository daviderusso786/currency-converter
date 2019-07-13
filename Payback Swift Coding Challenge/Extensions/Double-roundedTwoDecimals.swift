//
//  Double-roundedTwoDecimals.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
