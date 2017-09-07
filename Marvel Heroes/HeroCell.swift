//
//  HeroCell.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    weak var delegate: HeroCellDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroThumbnailView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func toggleFavoriteStatus(_ sender: UIButton) {
        delegate?.toggleFavoriteStatusForHero(at: self)
    }
}

protocol HeroCellDelegate: class {
    
    func toggleFavoriteStatusForHero(at cell: HeroCell)
}
