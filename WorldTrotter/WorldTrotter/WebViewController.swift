//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Jeffrey Johnson on 1/14/16.
//  Copyright © 2016 Jeffrey Johnson. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = webView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor, constant: 20)
        let leadingConstraint = webView.topAnchor.constraintEqualToAnchor(view.leadingAnchor)
        let rightConstraint = webView.topAnchor.constraintEqualToAnchor(view.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        rightConstraint.active = true
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.google.com/")!))
    }
    
    
    
}
