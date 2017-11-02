//
//  PeopleCell.swift
//  hala
//
//  Created by MAC on 03/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    @IBOutlet weak var blockImageView: UIImageView!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var hotImage: UIImageView!
    @IBOutlet weak var fbImageView: UIImageView!
     @IBOutlet weak var twImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        

        
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        userImageView.layer.borderWidth = 0.5
        userImageView.contentMode = .scaleToFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        favLabel.text = ""
        distanceLabel.text = ""
        ageLabel.text = ""
        nameLabel.text = ""
    }

}
