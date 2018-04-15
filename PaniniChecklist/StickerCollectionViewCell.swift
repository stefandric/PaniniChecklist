//
//  StickerCollectionViewCell.swift
//  PaniniChecklist
//
//  Created by Stefan Andric on 4/14/18.
//  Copyright © 2018 stefandric. All rights reserved.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var stickerNumber: UILabel!
    
    @IBOutlet weak var duplicateNumber: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        // Initialization code
    }
}
