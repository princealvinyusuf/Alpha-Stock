//
//  IntradayViewCell.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 31/03/21.
//

import UIKit

class IntradayViewCell: UITableViewCell {

    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    @IBOutlet weak var cellView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.2
        cellView.layer.shadowPath = UIBezierPath(rect: cellView.bounds).cgPath
        cellView.layer.shadowRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
