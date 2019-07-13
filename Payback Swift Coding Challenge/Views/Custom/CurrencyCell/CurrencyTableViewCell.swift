//
//  CurrencyTableViewCell.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import UIKit

protocol CurrencyCellView {
    func display(currency: String)
}

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CurrencyTableViewCell: CurrencyCellView {
    func display(currency: String) {
        currencyLabel.text = currency
    }
}

