//
//  ViewController.swift
//  QYPhotos
//
//  Created by Joggy on 16/4/28.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let screenWidth = UIScreen.mainScreen().bounds.width
    private let screenHeight = UIScreen.mainScreen().bounds.height
    
    var scroll: UIScrollView!
    
    var photos: QYPhotos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        photos = QYPhotos()
        photos.setBarItemColor(UIColor.whiteColor())
        photos.setBarTintColor(UIColor.redColor())
        photos.setSelectNumber(3)
        photos.delegate = self
        prepareForNav()
        prepareForLayout()
    }
    
    func prepareForNav() {
        let leftBut = UIButton(type: UIButtonType.Custom)
        leftBut.frame = CGRectMake(0, 0, 44, 44)
        leftBut.layer.position = CGPointMake(22, 22)
        leftBut.setTitle("show", forState: UIControlState.Normal)
        leftBut.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        leftBut.addTarget(self, action: #selector(selectPhotos), forControlEvents: UIControlEvents.TouchUpInside)
        let leftButItem = UIBarButtonItem(customView: leftBut)
        self.navigationItem.leftBarButtonItem = leftButItem
    }
    
    func prepareForLayout() {
        scroll = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight - 64))
        scroll.contentSize = CGSizeMake(scroll.frame.width, scroll.frame.height + 1)
        scroll.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scroll)
    }
    
    func selectPhotos() {
        print("show photos")
        photos.showPhotos(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: QYPhotosDelegate {
    
    func selectedPhotos(photos: [UIImage]) {
        for vie in scroll.subviews {
            vie.removeFromSuperview()
        }
        print(photos.count)
        if photos.count > 0 {
            for i in 0...photos.count - 1 {
                if i == 0 {
                    let imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenWidth*(photos[i].size.height/photos[i].size.width)))
                    imageView.image = photos[i]
                    scroll.addSubview(imageView)
                }
                else {
                    
                }
            }
        }
        else {
            
        }
    }
    
}






