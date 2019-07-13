//
//  HomePresenter.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 12/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

protocol HomeView: class {
    func refreshHomeView()
    func displayRateRetrievalError(title: String, message: String)
}

protocol HomePresenter {
    var exchangeRate: Double { get }
    var lastUpdate: String { get }
    var ratesStringArray: [String] { get }
    func convertCurrency(amount: Double, rate: Double) -> Double
}

class HomePresenterImplementation: HomePresenter {
    weak private var homeView : HomeView?
    var exchangeRate: Double = 0
    var timestamp : Double = 0
    var lastUpdate: String {
        get {
            let lastUpdateDate = Date(timeIntervalSince1970: timestamp)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: lastUpdateDate)
        }
    }
    var ratesDictionary = [String:Double]()
    var ratesStringArray : [String] {
        return ratesDictionary.keys.sorted { $0 < $1 }
    }
    
    init(view: HomeView) {
        self.homeView = view
    }
    
    func convertCurrency(amount: Double, rate: Double) -> Double {
        return (amount * rate).rounded(toPlaces: 2)
    }
    
    func getExchangeRatesForCurrency(currency: String) {        
        let lastUpdate = UserDefaults.standard.double(forKey: currency)
        
        if (Date().timeIntervalSince1970 > (lastUpdate + 86400) || lastUpdate == 0) {
            APIManager.shared.getExchangeRatesForCurrency(currency: currency, onSuccess: { (currencyRateResponse) in
                self.timestamp = currencyRateResponse.timestamp!
                self.ratesDictionary = currencyRateResponse.rates!
                self.homeView?.refreshHomeView()
            }, onFailure: { (error) in
                self.homeView?.displayRateRetrievalError(title: "Error", message: error.localizedDescription)
            })
        } else {
            let currencyRateResponse = CacheManager.shared.loadFile(withName: currency)
            self.ratesDictionary = currencyRateResponse!.rates!
            self.timestamp = currencyRateResponse!.timestamp!
            self.homeView?.refreshHomeView()
        }
        
    }
    
    func getCurrencyRateFor(finalCurrency: String) -> Double {
        return self.ratesDictionary[finalCurrency] ?? 0
    }
}
