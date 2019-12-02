//
//  GalleryInfoViewController.swift
//  Dai-Hentai
//
//  Created by David Dai on 12/1/19.
//  Copyright © 2019 DaidoujiChen. All rights reserved.
//

import UIKit

class GalleryInfoViewController: UIViewController {
    var manager = HentaiImagesManager()
    @objc var parser: AnyClass!
    @objc var info: HentaiInfo!
    let collectionViewHandler = GalleryCollectionViewHandler()
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var galleryTitle: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var loveCount: UILabel!
    @IBOutlet var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()
    }
    
    func initValues() {
        // Top view 的設定
        galleryTitle.text = info.bestTitle()
        category.text = info.category
        category.textColor = categoryColor(categoryString: info.category)
        rating.text = "★ " + info.rating
        coverImage.sd_setImage(with: URL(string: info.thumb ?? ""))
        
        self.galleryCollectionView.delegate = self.collectionViewHandler
        self.galleryCollectionView.dataSource = self.collectionViewHandler
        
        self.manager = HentaiDownloadCenter.manager(self.info, andParser: self.parser)
        self.manager.delegate = self
        
        if self.info.isDownloaded() {
            
        }
    }
//
//    // 讀取頁面相關設定
//    self.maxAllowScrollIndex = 0;
//    self.leaveByDelete = NO;
//
//    // 設定 navigation bar 上的標題
//    self.navigationItem.prompt = [self.info bestTitle];
//
//    // 在 navigation bar 上加一個下載的按鈕, 或是刪除掉的按鈕, 還有一個分享鈕
//
//    if ([self.info isDownloaded]) {
//        [self.manager giveMeAll];
//        self.navigationItem.rightBarButtonItems = @[ [self deleteButton], [self shareButton] ];
//    }
//    else {
//        self.navigationItem.rightBarButtonItems = @[ [self downloadButton], [self shareButton] ];
//    }
//
//    // 轉向時的判斷
//    self.rotating = NO;
//
//    // 顯示相關
//    for (UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionRight; direction <= UISwipeGestureRecognizerDirectionDown; direction <<= 1) {
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//        [swipe setDirection:direction];
//        [self.collectionView addGestureRecognizer:swipe];
//    }
    
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

extension GalleryInfoViewController: HentaiImagesManagerDelegate {
    func imageHeightChanged(atPageIndex pageIndex: Int) {
        return
    }
    
}

extension GalleryInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
