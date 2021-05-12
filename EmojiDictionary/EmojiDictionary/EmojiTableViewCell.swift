//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Степан Никитин on 04.03.2021.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func didTransition(to state: UITableViewCell.StateMask) {
//        super.didTransition(to: state)
//
//        if (state == UIT)
//    }
    
    func update(with emoji: Emoji) {
        symbolLabel.text = emoji.symbol
        nameLabel.text = emoji.name
        descriptionLabel.text = emoji.description
    }

}
