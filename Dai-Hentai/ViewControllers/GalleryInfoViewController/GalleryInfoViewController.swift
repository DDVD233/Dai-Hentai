//
//  GalleryInfoViewController.swift
//  Dai-Hentai
//
//  Created by David Dai on 12/1/19.
//  Copyright © 2019 DaidoujiChen. All rights reserved.
//

import UIKit

class GalleryInfoViewController: UIViewController {
    @objc var parser: AnyClass!
    @objc var info: HentaiInfo!
    @objc var delegate: GalleryViewControllerDelegate!
    private var manager: HentaiImagesManager?
    private let collectionViewHandler = GalleryCollectionViewHandler()
    private var leaveByDelete = false
    private var maxAllowScrollIndex = 0
    private var userCurrentIndex = 0
    private var rotating = false
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var galleryTitle: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var loveCount: UILabel!
    @IBOutlet var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()

        manager?.fetch({ isExist in
            if !isExist {
                self.galleryNotAppear()
            }
        })
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
        self.collectionViewHandler.delegate = self
        
        // 轉向時的判斷
        rotating = false
        
        self.manager = HentaiDownloadCenter.manager(self.info, andParser: self.parser)
        self.manager?.delegate = self
        
        if self.info.isDownloaded() {
            self.manager?.giveMeAll()
            self.navigationItem.rightBarButtonItems = [self.deleteButton(), self.shareButton()]
        } else {
            self.navigationItem.rightBarButtonItems = [self.downloadButton(), self.shareButton()]
        }
        
    }
    
// MARK: * Read button
    @IBAction func readPressed(_ sender: Any) {
        pushToGallery()
    }
    
// MARK: * navigation bar buttons
    func deleteButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteThis))
    }

    func downloadButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(giveMeAll))
    }

    func shareButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
// MARK: * navigation bar button action
    @objc func deleteThis() {
        UIAlertController.showAlertTitle("O3O", message: "我們現在這部作品囉!", defaultOptions: ["好 O3Ob"], cancelOption: "先不要好了 OwO\"", handler: { optionIndex in

            if optionIndex != 0 {
                self.leaveByDelete = true
                self.manager?.stop()
                HentaiDownloadCenter.bye(self.info)

                DBGallery.deleteDownloaded(self.info, handler: {
                    FilesManager.documentFolder().rd(self.info.folder())
                }, onFinish: { successed in
                    self.delegate.helpToReloadList()
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
    }

    @objc func giveMeAll() {
        manager?.giveMeAll()
        info.moveToDownloaded()
        navigationItem.rightBarButtonItems = [deleteButton(), shareButton()]
    }

    @objc func share() {
        var urlString = ExCookie.isExist() ? "https://exhentai.org" : "https://e-hentai.org"
        urlString += "/g/\(info.gid ?? "")/\(info.token ?? "")"

        let shareInfo = "\(info.bestTitle() ?? "")\n\(urlString)"
        let activityViewController = UIActivityViewController(activityItems: [shareInfo], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
// MARK: * 刷新顯示相關

    // 自動滑到某頁
    func scroll(to index: Int) {
        if maxAllowScrollIndex == 0 {
            return
        }
        
        galleryCollectionView.scrollToItem(at: IndexPath(row: index - 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
// MARK: * 提示窗
    func galleryNotAppear() {
        UIAlertController.showAlertTitle("O3O", message: "這部作品好像不見囉", defaultOptions: nil, cancelOption: "好 O3O", handler: nil)
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

extension GalleryInfoViewController: HentaiImagesManagerDelegate, GalleryCollectionViewHandlerDelegate {
    // MARK: - GalleryCollectionViewHandlerDelegate

    // 總共可顯示數量
    func totalCount() -> Int {
        return maxAllowScrollIndex
    }

    // 觸發讀取圖片
    func toggleLoadPages() {
        if userCurrentIndex + 20 >= manager?.imagePages.count ?? 0 {
            manager?.fetch(nil)
        }
    }

    // 觸發顯示圖片
    func toggleDisplayImage(at indexPath: IndexPath?, in cell: GalleryCell?) {
        guard let row = indexPath?.row else { return }
        if manager?.isReady(at: row) != nil {
            manager?.loadImage(at: row) { image in
                cell?.imageView.image = image
            }
            return
        }

        cell?.imageView.backgroundColor = UIColor.white
        cell?.imageView.image = HentaiImagesManager.placeholder()
        manager?.downloadImage(at: row)
    }

    // 取得該 cell 大小
    func cellSize(at indexPath: IndexPath?, in collectionView: UICollectionView?) -> CGSize {
        if rotating {
            return CGSize.zero
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (UIDevice.current.userInterfaceIdiom == .pad) ? 180 : (screenWidth / 2)
        let height = CGFloat(220.0)
        return CGSize(width: width, height: height)
    }

    // 回傳使用者正看到第幾頁
    func userCurrentIndex(_ index: Int) {
        userCurrentIndex = index
    }

// MARK: - HentaiImagesManager
    func imageHeightChanged(atPageIndex pageIndex: Int) {
        refreshMaxIndexAndReload(pageIndex)
    }
    
    // 刷新新 load 好的頁面
    func refreshMaxIndexAndReload(_ pageIndex: Int) {
        galleryCollectionView.reloadData()
        let preMaxAllowScrollIndex = maxAllowScrollIndex
        let sortKeys = manager?.heights.keysSortedByValue(comparator: { obj1, obj2 in
            return (obj1 as? NSNumber ?? 0).compare(obj2 as? NSNumber ?? 0)
        }) as? [NSNumber]
//
//        var insertIndexPaths: [AnyHashable] = []
        let sortKeysCount = sortKeys?.count ?? 0
//        for index in preMaxAllowScrollIndex..<sortKeysCount {
//            let sortKey = sortKeys?[index]
//            if let sortKey = sortKey {
//                if NSNumber(value: index).compare(sortKey) == .orderedSame {
//                    insertIndexPaths.append(IndexPath(row: index, section: 0))
//                } else {
//                    break
//                }
//            }
//        }
//
//        // 不確定preMaxAllowScrollIndex是不是一定比sortKeysCount小，保險起見還是做了check。
        maxAllowScrollIndex = preMaxAllowScrollIndex < sortKeysCount ? sortKeysCount : preMaxAllowScrollIndex
        
        // 不知道怎麼用
//
//        var reloadIndexPaths: [AnyHashable] = []
//        for cell in galleryCollectionView.visibleCells {
//            let indexPath = galleryCollectionView.indexPath(for: cell)
//            if indexPath != nil && indexPath?.row == pageIndex {
//                if let indexPath = indexPath {
//                    reloadIndexPaths.append(indexPath)
//                }
//                break
//            }
//        }
//
//        galleryCollectionView.performBatchUpdates({
//            if let reloadIndexPaths = reloadIndexPaths as? [IndexPath] {
//                self.galleryCollectionView.reloadItems(at: reloadIndexPaths)
//            }
//            if let insertIndexPaths = insertIndexPaths as? [IndexPath] {
//                self.galleryCollectionView.insertItems(at: insertIndexPaths)
//            }
//        })
    }
    
    func pushToGallery(page: Int = 0) {
        self.performSegue(withIdentifier: "PushToGallery", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let galleryViewController = segue.destination as? GalleryViewController
        galleryViewController?.delegate = delegate
        galleryViewController?.info = info
        galleryViewController?.parser = parser
        galleryViewController?.hidesBottomBarWhenPushed = true
    }
    
}
