###QYPhotos###
####使用Photos的相册图片获取控件



#####使用步骤

* 申请QYPhotos对象，并实现QYPhotosDelegate，可选择指定导航栏背景颜色和按钮颜色，可指定选择图片数量

		photos = QYPhotos()
        photos.setBarItemColor(UIColor.whiteColor())
        photos.setBarTintColor(UIColor.redColor())
        photos.setSelectNumber(3)
        photos.delegate = self
        
* 为当前页面添加用于呼出相册界面的按键，并为按键添加Target，在Target的方法中调用内部方法，并传递self参数

		func selectPhotos() {
        	photos.showPhotos(self)
   		}
   		
* 当前类继承QYPhotosDelegate，并实现`func selectedPhotos(photos: [UIImage])`方法，方法中photos为QYPhotos返回的选定的图片

* 示例

	![示例图片](示例图片.png)