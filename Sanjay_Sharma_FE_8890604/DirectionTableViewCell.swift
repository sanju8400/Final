//
//  DirectionTableViewCell.swift
//  Sanjay_Sharma_FE_8890604
//
//  Created by user238626 on 4/13/24.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var method: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var start: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with data: (String, String, String, String, String, String, String)) {
            direction.text = data.0
            city.text = data.1
            source.text = data.2
            start.text = data.3
            end.text = data.4
            method.text = data.5
            distance.text = data.6
        }

}

