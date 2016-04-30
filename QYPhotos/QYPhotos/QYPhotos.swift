//
//  QYPhotos.swift
//  QYPhotos
//
//  Created by Joggy on 16/4/28.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit
import Photos

protocol QYPhotosDelegate {
    func selectedPhotos(photos: [UIImage])
}

class QYPhotos: UIViewController {
    
    let spacing: CGFloat = 3
    let reuseIdentifier = "qyCell"
    
    private let screenWidth = UIScreen.mainScreen().bounds.width
    private let screenHeight = UIScreen.mainScreen().bounds.height

    private var photos: PHFetchResult!
    private var selectedAsset = [Bool]()
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    var delegate: QYPhotosDelegate!
    
    //setting
    private var numberOfSelected: Int = 1
    private var currentNumberOfSelected: Int = 0
    private var barItemColor = UIColor.whiteColor()
    private var barTintColor = UIColor.blueColor()
    
    private var lineOfItem: Int = 0
    private var withOfItem: CGFloat = 65
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareForNav()
        prepareForLayout()
    }
    
    private func prepareForNav() {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: barItemColor]
        self.navigationController?.navigationBar.barTintColor = barTintColor
        self.title = "相机胶卷"
        leftButton = UIButton(type: UIButtonType.System)
        leftButton.frame = CGRectMake(0, 0, 44, 44)
        leftButton.layer.position = CGPointMake(22, 22)
        leftButton.setTitle("取消", forState: UIControlState.Normal)
        leftButton.setTitleColor(barItemColor, forState: UIControlState.Normal)
        leftButton.addTarget(self, action: #selector(dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        rightButton = UIButton(type: UIButtonType.System)
        rightButton.frame = CGRectMake(0, 0, 88, 44)
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        rightButton.layer.position = CGPointMake(screenWidth - 22, 22)
        rightButton.setTitle("选择(0)", forState: UIControlState.Normal)
        rightButton.setTitleColor(barItemColor, forState: UIControlState.Normal)
        rightButton.addTarget(self, action: #selector(selectPhotos), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func prepareForLayout() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = CGSizeMake((screenWidth - 5*spacing)/4, (screenWidth - 5*spacing)/4)
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView = UICollectionView(frame: CGRectMake(0, 0, screenWidth, screenHeight - 64), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(QYPhotosCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        currentNumberOfSelected = 0
    }
    
    //MARK: -事件方法
    
    func setSelectNumber(number: Int) {
        self.numberOfSelected = number
    }
    
    func setBarItemColor(color: UIColor) {
        self.barItemColor = color
    }
    
    func setBarTintColor(color: UIColor) {
        self.barTintColor = color
    }
    
    func showPhotos(viewController: UIViewController) {
        let photoAuthorState = PHPhotoLibrary.authorizationStatus().rawValue
        if photoAuthorState == 0 {
            PHPhotoLibrary.requestAuthorization({ (status) in
                print(status.rawValue)
                switch status {
                case .Authorized:
                    self.presentPhotoView(viewController)
                    break
                default:
                    break
                }
            })
        }
        else {
            switch photoAuthorState {
            case 2:
                let alter = UIAlertController(title: "访问被拒绝", message: "请在'设置->隐私->照片'中允许访问相册", preferredStyle: UIAlertControllerStyle.Alert)
                alter.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
                alter.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
                viewController.presentViewController(alter, animated: true, completion: nil)
                break
            case 3:
                presentPhotoView(viewController)
                break
            default:
                break
            }
        }
    }
    
    func presentPhotoView(viewController: UIViewController) {
        self.getPhotos()
        let photosNav = UINavigationController(rootViewController: self)
        viewController.presentViewController(photosNav, animated: true, completion: nil)
    }
    
    func selectPhotos() {
        var images = [UIImage]()
        let manger = PHImageManager.defaultManager()
        let options = PHImageRequestOptions()
        options.version = PHImageRequestOptionsVersion.Original
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
        options.resizeMode = PHImageRequestOptionsResizeMode.Fast
        options.synchronous = true
        for i in 0...self.selectedAsset.count - 1 {
            if selectedAsset[i] {
                manger.requestImageDataForAsset(photos.objectAtIndex(i) as! PHAsset, options: options, resultHandler: { (data, str, ori, info) -> Void in
                    let image = UIImage(data: data!)
                    let leng = CGFloat(data!.length)/(1000.0*1000)
                    var scal: CGFloat = 1
                    if leng > 3 {
                        scal = 0.1
                    }
                    else if leng > 1 {
                        scal = 0.3
                    }
                    else if leng > 0.5 {
                        scal = 0.5
                    }
                    else {
                        scal = 1
                    }
                    let data1 = UIImageJPEGRepresentation(image!, scal)
                    let image1 = UIImage(data: data1!)
                    images.append(image1!)
                })
            }
        }
        delegate.selectedPhotos(images)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func getPhotos() {
        self.photos = PHAsset.fetchAssetsWithOptions(nil)
        self.selectedAsset = [Bool](count: self.photos.count, repeatedValue: false)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "错误", message: "最多选择取\(numberOfSelected)张", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension QYPhotos: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! QYPhotosCell
        if cell.selectButton.selected {
            cell.selectButton.selected = false
            currentNumberOfSelected -= 1
            rightButton.setTitle("选择(\(currentNumberOfSelected))", forState: UIControlState.Normal)
        }
        else if currentNumberOfSelected < numberOfSelected {
            cell.selectButton.selected = true
            currentNumberOfSelected += 1
            rightButton.setTitle("选择(\(currentNumberOfSelected))", forState: UIControlState.Normal)
        }
        else {
            showError()
        }
        selectedAsset[indexPath.row] = cell.selectButton.selected
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QYPhotosCell
        let option = PHImageRequestOptions()
        option.version = PHImageRequestOptionsVersion.Unadjusted
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
        option.resizeMode = PHImageRequestOptionsResizeMode.Fast
        let imageManager = PHImageManager.defaultManager()
        imageManager.requestImageForAsset(photos.objectAtIndex(indexPath.row) as! PHAsset, targetSize: CGSizeMake(screenWidth, screenHeight), contentMode: PHImageContentMode.Default, options: option) { (image, info) in
            dispatch_async(dispatch_get_main_queue(), { 
                cell.imageView.image = image
            })
        }
        return cell
    }
    
}


