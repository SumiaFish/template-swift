//
//  GiftChooseView.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol GiftChooseViewContextProtocol: NSObject {
    
    func send(gift: Gift)
    
}

protocol GiftChooseViewProtocol: UIView, GiftChooseViewContextProtocol  {
    
    var present: GiftChooseViewPresentProtocol? { get set }
    
    var context: GiftChooseViewContextProtocol? { get set }
    
//    func reloadGifts() -> Promise<Any?>
    
}

protocol GiftChooseViewPresentProtocol: NSObjectProtocol {
    
    var view: GiftChooseViewProtocol? { get set }
    
    var gifts: [Gift] { get }
    
    var selectedGift: Gift? { get }
    
    func loadGifts() -> Promise<[Gift]>
    
    func selecte(gift idx: Int)
    
    func selecte(gift: Gift)
    
}

let GiftChooseView_ItemRows = 4
let GiftChooseView_ItemCols = 2

class GiftChooseView: KVView {

    var present: GiftChooseViewPresentProtocol? {
        didSet {
            present?.view = self
        }
    }
    
    weak var context: GiftChooseViewContextProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if let hud = self.hud as? AppStateView {
            hud.activity.color = .white
        }
        
        collectionView.register(UINib(nibName: GiftCell.className, bundle: nil), forCellWithReuseIdentifier: GiftCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.numberOfPages = 1
        pageControl.currentPage = 1
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.isUserInteractionEnabled = false
        
    }
    
    override func display(_ isDisplay: Bool) {
        super.display(isDisplay)
        
        if isDisplay {
            if present?.gifts.count == 0 {
                hud?.show(.defaultLoadding())
                present?.loadGifts().then({ (it) -> [Gift] in
                    let val = (self.present?.gifts.count ?? 0) % (GiftChooseView_ItemRows * GiftChooseView_ItemCols)
                    self.pageControl.numberOfPages = (self.present?.gifts.count ?? 0) / (GiftChooseView_ItemRows * GiftChooseView_ItemCols) + ((val > 0) ? 1 : 0)
                    self.collectionView.reloadData()
                    return it
                }).catch({ (error) in
                    self.hud?.show(.showKVError(error))
                }).always {
                    self.hud?.show(.hide)
                }
            }
        }
    }

    @IBAction func sendAction(_ sender: Any) {
        if let gift = present?.selectedGift {
            send(gift: gift)
        }
    }
}

extension GiftChooseView: GiftChooseViewProtocol {
    
//    func reloadGifts() -> Promise<Any?> {
//        return Promise { (succ, error) in
//            succ(nil)
//        }
//    }
    
    
//    func reloadGifts() {
//        let val = (present?.gifts.count ?? 0) % (GiftChooseView_ItemRows * GiftChooseView_ItemCols)
//        pageControl.numberOfPages = (present?.gifts.count ?? 0) / (GiftChooseView_ItemRows * GiftChooseView_ItemCols) + ((val > 0) ? 1 : 0)
//        collectionView.reloadData()
//    }
    
    func send(gift: Gift) {
        context?.send(gift: gift)
    }
    
}

extension GiftChooseView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x / collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return present?.gifts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCell.className, for: indexPath) as! GiftCell
        cell.gift = present?.gifts[indexPath.item] ?? nil
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(GiftChooseView_ItemRows), height: collectionView.bounds.height / CGFloat(GiftChooseView_ItemCols))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        present?.selecte(gift: indexPath.item)
//        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        collectionView.reloadData()
    }
    
}

class GiftChooseViewPresent: NSObject, GiftChooseViewPresentProtocol {
     
     weak var view: GiftChooseViewProtocol?

     var gifts: [Gift] = []
     
     var selectedGift: Gift?
     
    func loadGifts() -> Promise<[Gift]> {
        return GiftData.loadData().then { (data) -> [Gift] in
            self.gifts.removeAll()
            self.gifts.append(contentsOf: data.data ?? [])
            return self.gifts
        }
    }
    
//     func loadGifts() {
//         self.view?.hud?.show(.defaultLoadding())
//         GiftData.loadData().then { (data) in
//             self.gifts.removeAll()
//             self.gifts.append(contentsOf: data.data ?? [])
//             self.view?.reloadGifts()
//             self.view?.hud?.show(.success(nil))
//         }.catch { (error) in
//             self.view?.hud?.show(.showKVError(error))
//         }
//     }
     
     func selecte(gift idx: Int) {
         for i in 0..<gifts.count {
             if i == idx {
                 gifts[i].isSelected = true
                 selecte(gift: gifts[i])
             } else {
                 gifts[i].isSelected = false
             }
         }
     }
     
     func selecte(gift: Gift) {
         selectedGift = gift
     }
    
}
