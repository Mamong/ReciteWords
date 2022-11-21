//
//  PagerViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/15.
//

import UIKit

class PagerViewController: UIViewController {
    var titleCollectionView: UICollectionView!
    var pageViewController: UIPageViewController!
    var titleArray: [String] = []
    var currentIndex = 0
    var viewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        addCollectionView()
        addPageViewController()
    }
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 44)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        titleCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        titleCollectionView.showsHorizontalScrollIndicator = false
        titleCollectionView.backgroundColor = UIColor.white
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        view.addSubview(titleCollectionView)
        
        titleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        titleCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if #available(iOS 11.0, *) {
            titleCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            titleCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        titleCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "cell-title")
    }
    
    func addPageViewController() {
        pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing:0])
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.backgroundColor = UIColor.white
        pageViewController.view.translatesAutoresizingMaskIntoConstraints =  false
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: titleCollectionView.bottomAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func scrollTab(to indexPath:IndexPath) {
        titleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        titleCollectionView.reloadData()
    }
    
    open func setViewControllers(_ viewControllers: [UIViewController], titles:[String]){
        self.titleArray = titles
        self.viewControllers = viewControllers
        titleCollectionView.reloadData()
        let vc = viewControllers.first!
        pageViewController.setViewControllers([vc], direction: .reverse, animated: true)
    }
}

extension PagerViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-title", for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = titleArray[item]
        cell.isSelected = currentIndex == item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        let vc = viewControllers[item]
        if item > currentIndex {
            pageViewController.setViewControllers([vc], direction: .forward, animated: true)
        }else{
            pageViewController.setViewControllers([vc], direction: .reverse, animated: true)
        }
        currentIndex = item
        scrollTab(to: indexPath)
    }
}

extension PagerViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController)
        if let idx = index, idx > 0 {
            let before = idx - 1
            return viewControllers[before]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController)
        if let idx = index, idx < viewControllers.count-1 {
            let after = idx + 1
            return viewControllers[after]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let nextVC = pendingViewControllers.first!
        let index = viewControllers.firstIndex(of: nextVC)!
        currentIndex = index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let indexPath = IndexPath.init(item: currentIndex, section: 0)
            scrollTab(to: indexPath)
        }
    }
}

class TitleCollectionViewCell: UICollectionViewCell {
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.gray
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override var isSelected: Bool{
        didSet{
            titleLabel.textColor = isSelected ? UIColor.red : UIColor.gray
        }
    }
}

