//
//  Endpoint.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 12/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

enum Endpoints {
    
    case getExchangeRatesForCurrency(String)
    
    var baseURL: URL {
        return URL(string: "http://data.fixer.io/api/")!
    }
    
    var path: String {
        switch self {
        case .getExchangeRatesForCurrency(let currency): return "/latest?access_key=47488eeb5916dca62f7766d95b11f78c&base=\(currency)"
        }
    }
    
    var url: URL {
        let path = self.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let baseURL = self.baseURL
        let url = URL(string: path!, relativeTo: baseURL)
        return url!
    }
}
