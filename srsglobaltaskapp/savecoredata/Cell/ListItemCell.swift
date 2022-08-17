//
//  ListCell.swift
//  srsglobaltaskapp
//
//  Created by CV on 8/17/22.
//

import UIKit

class ListItemCell: UITableViewCell {

    @IBOutlet weak var namelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
