//
//  SubscriptionCell.swift
//  hala
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var earnLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
