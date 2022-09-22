//
//  RecipesTableViewCell.swift
//  Reciplease
//
//  Created by TomF on 22/09/2022.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(like: Int, time: Int, title: String, subtitle: String) {
        likeLabel.text = String(like)
        timeLabel.text = String(time)
        subTitleLabel.text = subtitle
        titleLabel.text = title
    }
}
