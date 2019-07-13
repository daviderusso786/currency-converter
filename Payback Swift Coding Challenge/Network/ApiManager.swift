//
//  ApiManager.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 12/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

class APIManager {
    static let shared: APIManager = APIManager()
    
    // MARK: GET
    func getExchangeRatesForCurrency(currency: String, onSuccess: @escaping(CurrencyRateResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        // Configuration
        let requestURL = URLRequest(url: Endpoints.getExchangeRatesForCurrency(currency).url)
        
        // Session
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                let lastUpdate = UserDefaults.standard.double(forKey: currency)
                
                if (lastUpdate != 0) {
                    let currencyRateResponse = CacheManager.shared.loadFile(withName: currency)
                    onSuccess(currencyRateResponse!)
                } else {
                    onFailure(error!)
                }
            }
            
            guard let data = data else { return }
            
            do {
                let currencyRateResponse = try JSONDecoder().decode(CurrencyRateResponse.self, from: data)
                
                if currencyRateResponse.success {
                    CacheManager.shared.save(obj: currencyRateResponse, withName: currencyRateResponse.base!)
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: currencyRateResponse.base!)
                    UserDefaults.standard.synchronize()
                    onSuccess(currencyRateResponse)
                } else {
                    let error = NSError(domain: "", code: currencyRateResponse.error!.code, userInfo: nil)
                    onFailure(error)
                }
            } catch let jsonError {
                onFailure(jsonError)
                print(jsonError)
            }
            }.resume()
    }
}
