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
    
    func updateUserAgent(){
        let newUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        let dic = ["UserAgent" : newUserAgent]
        UserDefaults.standard.register(defaults: dic)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUserAgent()
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
