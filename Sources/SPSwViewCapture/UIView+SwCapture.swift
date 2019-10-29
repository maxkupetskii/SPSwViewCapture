//
//  UIView+SwCapture.swift
//  SwViewCapture
//
//  Created by chenxing.cx on 16/2/17.
//  Copyright © 2016年 Startry. All rights reserved.
//

import UIKit
import WebKit
import ObjectiveC

private var SwViewCaptureKey_IsCapturing: String = "SwViewCapture_AssoKey_isCapturing"

public extension UIView {
    
    @objc func swSetFrame(_ frame: CGRect) {
        // Do nothing, use for swizzling
    }
    
    var isCapturing:Bool! {
        get {
            let num = objc_getAssociatedObject(self, &SwViewCaptureKey_IsCapturing)
            if num == nil {
                return false
            }
            
            if let numObj = num as? NSNumber {
                return numObj.boolValue
            }else {
                return false
            }
        }
        set(newValue) {
            let num = NSNumber(value: newValue as Bool)
            objc_setAssociatedObject(self, &SwViewCaptureKey_IsCapturing, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Ref: chromium source - snapshot_manager, fix wkwebview screenshot bug.
    // https://chromium.googlesource.com/chromium/src.git/+/46.0.2478.0/ios/chrome/browser/snapshots/snapshot_manager.mm
    func swContainsWKWebView() -> Bool {
        if self.isKind(of: WKWebView.self) {
            return true
        }
        for subView in self.subviews {
            if (subView.swContainsWKWebView()) {
                return true
            }
        }
        return false
    }

}

