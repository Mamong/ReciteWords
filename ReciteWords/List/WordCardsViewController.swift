//
//  WordCardsViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/27.
//

import UIKit

class WordCardsViewController: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let size = collectionView.frame.size
        //collectionView.contentSize = CGSize(width: 10*size.width, height: size.height)
        //let layout = collectionView.collectionViewLayout as! WordCardsLayout

        //        layout.itemSize = CGSize.init(width: size.width - 2*40, height: size.height - 2*50)
//        layout.minimumInteritemSpacing = 80
//        layout.minimumLineSpacing = 40
        collectionView.reloadData()
    }
}

extension WordCardsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-id", for: indexPath) as! WordCardCell
        cell.wordLabel.text = "xxxxx"
        return cell
    }
}

class WordCardCell: UICollectionViewCell {
    @IBOutlet weak var wordLabel:UILabel!

}


class WordCardsLayout:UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()

        scrollDirection = .horizontal
        let inset:CGFloat = 24
        itemSize = CGSize(width: collectionView!.bounds.width - 2*inset, height: 540)
        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        minimumLineSpacing = inset*2
    }
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        guard collectionView != nil else {
            return nil
        }
        guard let atts = NSArray.init(array: attrs, copyItems: true) as? [UICollectionViewLayoutAttributes] else{
            return nil
        }
         
        let width = collectionView!.frame.size.width
        let height = collectionView!.frame.size.height
        let contentOffset = collectionView!.contentOffset
        
        //let visibleRect = CGRect(origin: contentOffset, size: collectionView!.bounds.size)
        let radius:CGFloat = height * 4
        let centerX = contentOffset.x + width * 0.5
        for att in atts {
            let delta = att.center.x - centerX
            if abs(delta) <= width{
                let theta = asin(delta/radius)
                let dx:CGFloat = itemSize.height*sin(theta)/2
                let dy:CGFloat = itemSize.height*(1-cos(theta))/2+radius*(1-cos(theta))
                att.transform = CGAffineTransform(translationX: dx, y: dy).concatenating(CGAffineTransform(rotationAngle: theta))

            }
        }
        return atts
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        var offset:CGFloat = CGFloat(MAXFLOAT)
//
//        let hCenter = proposedContentOffset.x + (collectionView!.bounds.width / 2.0);
//
//        let currentRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height);
//
//        let array = super.layoutAttributesForElements(in: currentRect)!
//        for layoutAttributes in array
//        {
//            let itemHorizontalCenter = layoutAttributes.center.x
//            if abs(itemHorizontalCenter - hCenter) < abs(offset) {
//                offset = itemHorizontalCenter - hCenter
//            }
//        }
//
//        return CGPoint(x: proposedContentOffset.x + offset, y: proposedContentOffset.y)
//    }
}
