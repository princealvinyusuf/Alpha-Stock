//
//  CompareViewCell.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 11/04/21.
//

import UIKit

class CompareViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var lowValue: UILabel!
    @IBOutlet weak var openValue: UILabel!
    
    
    @IBOutlet weak var view: UIView!
    
    
    
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
