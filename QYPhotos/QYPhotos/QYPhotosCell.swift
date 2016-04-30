//
//  QYPhotosCell.swift
//  QYPhotos
//
//  Created by Joggy on 16/4/28.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class QYPhotosCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var selectButton: UIButton!
    var isSelectedItem: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.width))
        imageView.image = UIImage(named: "QYPhotos.bundle/icon_holder")
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(imageView)
        selectButton = UIButton(type: UIButtonType.Custom)
        let img = UIImage(named: "QYPhotos.bundle/icon")
        selectButton.frame = CGRectMake(self.frame.width - 20, 0, 20, 20)
        selectButton.contentMode = UIViewContentMode.ScaleAspectFit
        selectButton.setImage(img?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Selected)
        selectButton.layer.borderColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).CGColor
        selectButton.layer.borderWidth = 1
        selectButton.layer.cornerRadius = 3
        self.contentView.addSubview(selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
