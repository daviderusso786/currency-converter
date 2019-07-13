//
//  CurrencyViewController.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import UIKit

protocol CurrencyControllerDelegate: class {
    func didSelectBaseCurrency(currency: String)
    func didSelectFinalCurrency(currency: String)
}

class CurrencyViewController: UIViewController {
    
    weak var delegate : CurrencyControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    let CELL_IDENTIFIER = "currencyCell"
    var presenter: CurrencyPresenterImplementation!
    var isBaseSelectionMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        presenter = CurrencyPresenterImplementation(view: self)
        presenter.getCurrencies()
    }
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCurrencies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as? CurrencyTableViewCell
        presenter.configure(cell: cell!, forRow: indexPath.row)
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isBaseSelectionMode {
            delegate?.didSelectBaseCurrency(currency: presenter.currenciesArray[indexPath.row])
        } else {
            delegate?.didSelectFinalCurrency(currency: presenter.currenciesArray[indexPath.row])
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencyViewController: CurrencyView {    
    func refreshCurrencyView() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}
