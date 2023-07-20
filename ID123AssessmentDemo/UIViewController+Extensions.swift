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

extension UITableView {
    func showLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
    
    func hideLoadingFooter() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
}
