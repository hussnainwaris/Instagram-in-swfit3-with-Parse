//
//  FeedTableViewCell.swift
//  InstaParse
//
//  Created by MacBook Pro on 07/04/2017.
//  Copyright © 2017 apphouse. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var messageDescription: UILabel!
    @IBOutlet var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
