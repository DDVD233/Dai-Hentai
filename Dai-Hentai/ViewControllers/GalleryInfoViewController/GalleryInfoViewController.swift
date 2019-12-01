//
//  GalleryInfoViewController.swift
//  Dai-Hentai
//
//  Created by David Dai on 12/1/19.
//  Copyright © 2019 DaidoujiChen. All rights reserved.
//

import UIKit

class GalleryInfoViewController: UIViewController {
    @objc var info = HentaiInfo()
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var galleryTitle: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var loveCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()
    }
    
    func initValues() {
        galleryTitle.text = info.bestTitle()
        category.text = info.category
        category.textColor = categoryColor(categoryString: info.category)
        rating.text = "★ " + info.rating
        coverImage.sd_setImage(with: URL(string: info.thumb ?? ""))
    }
    
    func categoryColor(categoryString: String) -> UIColor {
        switch categoryString {
        case "Doujinshi":
            return color(r: 255, g: 59, b: 59)
        case "Manga":
            return color(r: 255, g: 186, b: 59)
        case "Artist CG Sets":
            return color(r: 234, g: 220, b: 59)
        case "Game CG Sets":
            return color(r: 59, g: 157, b: 59)
        case "Western":
            return color(r: 164, g: 255, b: 76)
        case "Non-H":
            return color(r: 76, g: 180, b: 255)
        case "Image Sets":
            return color(r: 59, g: 59, b: 255)
        case "Cosplay":
            return color(r: 117, g: 59, b: 159)
        case "Asian Porn":
            return color(r: 243, g: 176, b: 243)
        case "Misc":
            return color(r: 212, g: 212, b: 212)
        default:
            return UIColor.white
        }
    }
    
    
    func color(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1.0)
    }
}
