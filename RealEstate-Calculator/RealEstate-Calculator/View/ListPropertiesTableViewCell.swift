//
//  ListPropertiesTableViewCell.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/10/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

import UIKit

class ListPropertiesTableViewCell: UITableViewCell {
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var propertyWorthLabel: UILabel!
    // TODO:
    
    // create UIView - call this container view make the corner radius round
    @IBOutlet weak var containerView: UIView!
    
//    required convenience init?(coder aDecoder: NSCoder) {
//        self.init(coder: aDecoder)
//        
//        containerView.layer.cornerRadius = 30
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 30
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
