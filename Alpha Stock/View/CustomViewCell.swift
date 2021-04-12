//
//  CustomViewCell.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 12/04/21.
//

import UIKit

class CustomViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var openValue: UILabel!
    @IBOutlet weak var closeValue: UILabel!
    @IBOutlet weak var lowValue: UILabel!
    @IBOutlet weak var highValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        

        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0 )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
