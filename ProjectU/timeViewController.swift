//
//  timeViewController.swift
//  ProjectU
//
//  Created by Naoya on 2018/01/12.
//  Copyright © 2018年 サイトウナオヤッチ. All rights reserved.
//

import UIKit

class timeViewController: UIViewController {
    @IBOutlet weak var setTime: UILabel!
    @IBOutlet weak var rema_time: UILabel!
    @IBOutlet weak var upTime: UIDatePicker!
    
    //何分後だったかを入れる変数。
    var result_time:Int = 0

    //データフォーマット。取得する値はwhichの値で異なる。
    func dateFormat(which: Int,date: Date)->(String){
        let formatter = DateFormatter()
        if which == 0{
            formatter.dateFormat = "dd"//日
        }else if which == 1{
            formatter.dateFormat = "HH"//時
        }else if which == 2{
            formatter.dateFormat = "mm"//分
        }else if which == 3{
            formatter.dateFormat = "MM"//月(月を跨ぐ処理に使用。ただしコードはまだない。)
        }
        return formatter.string(from: date)
    }
    
    //設定時間の計算処理
    func culcTime(){
        let now = Date()
        //現在時刻と設定時刻を分換算
        let now_time = Int(dateFormat(which: 1, date: now))!*60 + Int(dateFormat(which: 2, date: now))!
        let set_time = Int(dateFormat(which: 1, date: upTime.date))!*60 + Int(dateFormat(which: 2, date: upTime.date))!

        if dateFormat(which: 0, date: now) == dateFormat(which: 0, date: upTime.date){
            //設定日が当日だった場合
            result_time = set_time - now_time
            if result_time >= 0{
                if result_time > 60{
                    setTime.text = "\(result_time/60)時間\(result_time%60)分後です"
                }else{
                    setTime.text = "\(result_time)分後です"
                }
            }else{
                setTime.text = "時間が過ぎています"
            }
        }else{
            //設定日が当日じゃない場合
            let set_day:String = dateFormat(which: 0, date: upTime.date)
            let now_day:String = dateFormat(which: 0, date: now)
            let diff_day:Int = Int(set_day)! - Int(now_day)!
            let before_time = 24*60 - now_time
            let after_time = set_time
            if diff_day >= 0{
                result_time = before_time + after_time + (diff_day-1)*24*60
                if result_time > 1440{
                    let day = result_time/1400
                    let hour = result_time - (day*1440)
                    setTime.text = "\(day)日\(hour/60)時間\(hour%60)分後です"
                }else if result_time > 60{
                    setTime.text = "\(result_time/60)時間\(result_time%60)分後です"
                }else{
                    setTime.text = "\(result_time)分後です"
                }
            }else{
                setTime.text = "日にちが過ぎています"
            }
        }
        
        
    }
    //残り時間のカウントダウン
    func remaining_hour(){
        
    }
    
    //ボタンクリック動作
    @IBAction func uptime_push(_ sender: UIButton) {
        let alert = UIAlertController(title:"時間設定",message:"起床時間の設定です",preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"時間を設定する",style:UIAlertActionStyle.default,handler:{
            (action: UIAlertAction!) in
            self.culcTime()
            self.remaining_hour()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upTime.date = Date()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
