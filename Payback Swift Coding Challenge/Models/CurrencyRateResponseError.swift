//
//  CurrencyRateResponseError.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

struct CurrencyRateResponseError: Codable {
    let code: Int
    let info: String
}
