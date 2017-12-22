//
//  HomeViewController.swift
//  ProjectU
//
//  Created by Naoya on 2017/12/23.
//  Copyright © 2017年 osyou. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeWebView: UIWebView!
    var url:String = "http://ec2-52-192-46-109.ap-northeast-1.compute.amazonaws.com"
    
    func loadURL(){
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL!)
        homeWebView.loadRequest(request)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
