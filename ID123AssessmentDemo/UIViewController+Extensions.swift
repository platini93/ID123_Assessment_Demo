//
//  UIViewController+Extensions.swift
//  MVVM_Demo
//
//  Created by Zentech-038 on 16/12/22.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    //Loader
    func showActivityIndicator(progressLabel:String = "") {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
        progressHUD.label.numberOfLines = 2
    }
    
    func hideActivityIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}
