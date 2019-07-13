//
//  HomeViewController.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 12/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    @IBOutlet weak var finalCurrencyTextField: UITextField!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var finalCurrencyButton: UIButton!
    
    var selectedBaseCurrency = "AED"
    var selectedFinalCurrency = "AED"
    var presenter: HomePresenterImplementation!
    var activityView : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.baseCurrencyTextField.text = "0"
        self.finalCurrencyTextField.text = "0"
        self.baseCurrencyTextField.delegate = self

        presenter = HomePresenterImplementation(view: self)
        presenter.getExchangeRatesForCurrency(currency: "AED")
    }
    
    func convertCurrentAmount() {
        let currentAmount = Double(self.baseCurrencyTextField.text!)
        let currentRate = Double(self.exchangeRateLabel.text!)
        self.finalCurrencyTextField.text = String(self.presenter.convertCurrency(amount: currentAmount!, rate: currentRate!))
    }
    
    func updateExchangeRate() {
        let rate = self.presenter.getCurrencyRateFor(finalCurrency: selectedFinalCurrency)
        self.exchangeRateLabel.text = String(rate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func baseCurrencyButtonPressed(_ sender: UIButton) {
        let currencyVC = self.storyboard?.instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        currencyVC.delegate = self
        currencyVC.isBaseSelectionMode = true
        present(currencyVC, animated: true, completion: nil)
    }
    
    
    @IBAction func finalCurrencyButtonPressed(_ sender: UIButton) {
        let currencyVC = self.storyboard?.instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        currencyVC.delegate = self
        currencyVC.isBaseSelectionMode = false
        present(currencyVC, animated: true, completion: nil)
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        if baseCurrencyTextField.text != "" {
            baseCurrencyTextField.text = String(Int(baseCurrencyTextField.text!)!)
        } else {
            baseCurrencyTextField.text = "0"
        }
        
        self.convertCurrentAmount()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        container.backgroundColor = .clear
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView!.center = self.view.center
        activityView!.startAnimating()
        
        container.addSubview(activityView!)
        self.view.addSubview(container)
        activityView!.startAnimating()
    }
}

extension HomeViewController: CurrencyControllerDelegate {
    func didSelectBaseCurrency(currency: String) {
        selectedBaseCurrency = currency
        baseCurrencyButton.setTitle(selectedBaseCurrency, for: .normal)
        presenter.getExchangeRatesForCurrency(currency: selectedBaseCurrency)
    }
    
    func didSelectFinalCurrency(currency: String) {
        selectedFinalCurrency = currency
        finalCurrencyButton.setTitle(selectedFinalCurrency, for: .normal)
        self.updateExchangeRate()
        self.convertCurrentAmount()
        self.lastUpdateLabel.text = self.presenter.lastUpdate
    }
}

extension HomeViewController: HomeView {    
    func displayRateRetrievalError(title: String, message: String) {
        presentAlert(withTitle: title, message: message)
    }
    
    func refreshHomeView() {
        DispatchQueue.main.async {
            self.updateExchangeRate()
            self.convertCurrentAmount()
            self.lastUpdateLabel.text = self.presenter.lastUpdate
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString?, currentText.replacingCharacters(in: range, with: string).count <= 10 else {
                return false
        }
        return true
    }
}
