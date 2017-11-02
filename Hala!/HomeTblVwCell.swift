//
//  HomeTblVwCell.swift
//  hala
//
//  Created by OSX on 13/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import UIKit

class HomeTblVwCell: UITableViewCell {

    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser.clipsToBounds = true
        imgUser.contentMode = .scaleToFill
        imgUser.layer.borderColor = UIColor.lightGray.cgColor
        imgUser.layer.borderWidth = 0.5
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
