//
//  CurrencyPresenter.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

protocol CurrencyView: class {
    func refreshCurrencyView()
}

protocol CurrencyPresenter {
    var numberOfCurrencies: Int { get }
    var ratesDictionary: [String:Double] { get }
    var currenciesArray: [String] { get }
    func getCurrencies()
}

class CurrencyPresenterImplementation: CurrencyPresenter {
    weak private var currencyView : CurrencyView?
    
    var numberOfCurrencies: Int {
        return currenciesArray.count
    }
    var ratesDictionary = [String:Double]()
    
    var currenciesArray : [String] {
        return ratesDictionary.keys.sorted { $0 < $1 }
    }
    
    init(view: CurrencyView) {
        self.currencyView = view
    }
    
    func configure(cell: CurrencyTableViewCell, forRow row: Int) {
        cell.display(currency: currenciesArray[row])
    }
    
    func getCurrencies() {
        let lastUpdate = UserDefaults.standard.double(forKey: "AED")
        
        if (Date().timeIntervalSince1970 > (lastUpdate + 86400) || lastUpdate == 0) {
            APIManager.shared.getExchangeRatesForCurrency(currency: "AED", onSuccess: { (currencyRateResponse) in
                self.ratesDictionary = currencyRateResponse.rates!
                self.currencyView?.refreshCurrencyView()
            }, onFailure: { (error) in
                print(error.localizedDescription)
            })
        } else {
            let currencyRateResponse = CacheManager.shared.loadFile(withName: "AED")
            self.ratesDictionary = currencyRateResponse!.rates!
            self.currencyView?.refreshCurrencyView()
        }
    }
}
