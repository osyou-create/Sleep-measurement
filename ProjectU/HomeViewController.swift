//
//  HomeViewController.swift
//  ProjectU
//
//  Created by Naoya on 2017/12/23.
//  Copyright © 2018年 osyou. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeWebView: UIWebView!
    var url:String = "https://project-u.site"
    
    func loadURL(){
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL!)
        homeWebView.loadRequest(request)
    }
    
    func updateUserAgent(){
        let newUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        let dic = ["UserAgent" : newUserAgent]
        UserDefaults.standard.register(defaults: dic)
    }
    
    
    override func viewDidLoad() {
        self.updateUserAgent()
        super.viewDidLoad()
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
