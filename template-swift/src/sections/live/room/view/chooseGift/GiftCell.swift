//
//  GiftCell.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GiftCell: UICollectionViewCell {

    var gift: Gift? {
        didSet {
            titleLab.text = gift?.name
            imgView.sd_setImage(with: URL(string: gift?.icon ?? ""), completed: nil)
            selecteBG.isHidden = gift?.isSelected == false 
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var selecteBG: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.contentMode = .scaleAspectFit
        selecteBG.isHidden = true
    }

}
