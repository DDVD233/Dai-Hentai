//
//  GalleryMoreInfoCell.swift
//  Dai-Hentai
//
//  Created by 戴元平 on 12/1/19.
//  Copyright © 2019 DaidoujiChen. All rights reserved.
//

import Foundation

class GalleryMoreInfoCell: GalleryCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFit
        self.backgroundView?.backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.backgroundColor = .white
    }
}
