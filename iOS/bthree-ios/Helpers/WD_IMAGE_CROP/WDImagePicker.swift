//
//  WDImagePicker.swift
//  WDImagePicker
//
//  Created by Wu Di on 27/8/15.
//  Copyright (c) 2015 Wu Di. All rights reserved.
//

import UIKit

@objc public protocol WDImagePickerDelegate {
    @objc optional func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage)
    @objc optional func imagePickerDidCancel(_ imagePicker: WDImagePicker)
    
}

@objc open class WDImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WDImageCropControllerDelegate {
    open var delegate: WDImagePickerDelegate?
    open var cropSize: CGSize!
    open var resizableCropArea = false
    //JMODE + GIT
    open var lockAspectRatio = false
    fileprivate var _imagePickerController: UIImagePickerController!
    
    open var imagePickerController: UIImagePickerController {
        return _imagePickerController
    }
    //
    //    override public init() {
    //        super.init()
    //        let bounds = UIScreen.mainScreen().bounds
    //        let width = bounds.size.width
    //        let height = bounds.size.height
    //        self.cropSize = CGSizeMake(width, height)
    //        _imagePickerController = UIImagePickerController()
    //        _imagePickerController.delegate = self
    //        _imagePickerController.sourceType = .PhotoLibrary
    //    }
    
    public init(withSourceType sourceType : UIImagePickerController.SourceType) {
        super.init()
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        print("width \(width) height \(height)")
        self.cropSize = CGSize(width: width, height: height)
        _imagePickerController = UIImagePickerController()
        _imagePickerController.delegate = self
        _imagePickerController.sourceType = sourceType
    }
    fileprivate func hideController() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        self._imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if self.delegate?.imagePickerDidCancel != nil {
            self.delegate?.imagePickerDidCancel!(self)
        } else {
            self.hideController()
        }
    }
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let cropController = WDImageCropViewController()
        cropController.sourceImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        cropController.resizableCropArea = self.resizableCropArea
        //JMODE   + git
        cropController.lockAspectRatio = self.lockAspectRatio
        cropController.cropSize = self.cropSize
        cropController.delegate = self
        picker.pushViewController(cropController, animated: true)
    }
    
    //    func setImage(img:UIImage) {
    //        let cropController = WDImageCropViewController()
    //        cropController.sourceImage = img
    //        cropController.resizableCropArea = self.resizableCropArea
    //        cropController.cropSize = self.cropSize
    //        cropController.delegate = self
    //        _imagePickerController.pushViewController(cropController, animated: true)
    //
    //    }
    
    func imageCropController(_ imageCropController: WDImageCropViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.delegate?.imagePicker?(self, pickedImage: croppedImage)
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        hideController()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
