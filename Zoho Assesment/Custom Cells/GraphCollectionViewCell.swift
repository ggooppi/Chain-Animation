//
//  GraphCollectionViewCell.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 05/01/20.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plantImageView.roundedCorners(radius: 6)
        plantImageView.isUserInteractionEnabled = true
    }
}
