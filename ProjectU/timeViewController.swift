//
//  timeViewController.swift
//  ProjectU
//
//  Created by Naoya on 2018/01/12.
//  Copyright © 2018年 osyou. All rights reserved.
//

import UIKit

class timeViewController: UIViewController {

    var temp:String!
    var temp2:String!
    var temp_second:Int!

    @IBOutlet weak var uptime_label: UILabel!
    @IBOutlet weak var uptime_label2: UILabel!
    @IBOutlet weak var sunup: UISwitch!
    @IBAction func uptime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH"
        formatter2.dateFormat = "mm"
        temp = formatter.string(from: sender.date)
        temp2 = formatter2.string(from: sender.date)
        
    }
    @IBAction func uptime_push(_ sender: UIButton) {
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date()
        */
        uptime_label.text = temp
        temp_second = Int(temp)!*3600 + Int(temp2)!*60
        print(String(temp_second))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(temp_second)) {
            print("aaaaa")
        }

    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
