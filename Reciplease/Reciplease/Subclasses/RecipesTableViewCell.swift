//
//  RecipesTableViewCell.swift
//  Reciplease
//
//  Created by TomF on 22/09/2022.
//

import UIKit
import SDWebImage

class RecipesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Constants
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.frame = recipeImage.bounds
        gradient.colors = [startColor, endColor]
        recipeImage.layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Function used to configure a RecipeTableViewCell
    /// - Parameters:
    ///   - like: Optionnal String
    ///   - time: Optionnal String
    ///   - title: Optionnal String
    ///   - subtitle: Optionnal String
    ///   - image: Optionnal String
    ///   - uri: Optionnal String
    func configure(like: String?, time: String?, title: String?, subtitle: String?, image: String?, uri: String?) {
        likeLabel.text = "\(like!)"
        timeLabel.text = "\(time!)"
        subTitleLabel.text = subtitle
        titleLabel.text = title
        
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.sd_setImage(with: URL(string: image ?? ""))
    }
}
