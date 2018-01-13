//
//  HomeViewController.swift
//  ProjectU
//
//  Created by Naoya on 2017/12/23.
//  Copyright © 2018年 osyou. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    func loadURL(){
        let url = URL(string: "https://project-u.site")
        let urlRequest = URLRequest(url: url!)
        
        webView.load(urlRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
