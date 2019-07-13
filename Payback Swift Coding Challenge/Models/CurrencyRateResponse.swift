//
//  CurrencyRateResponse.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 12/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

struct CurrencyRateResponse: Codable {
    let success : Bool
    let timestamp : Double?
    let base : String?
    let date : String?
    let rates : [String:Double]?
    let error: CurrencyRateResponseError?
}
