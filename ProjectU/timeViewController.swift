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
    
    let now = Date()

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
        //現在時刻と設定時刻を分換算
        let now_time = Int(dateFormat(which: 1, date: now))!*60 + Int(dateFormat(which: 2, date: now))!
        let set_time = Int(dateFormat(which: 1, date: upTime.date))!*60 + Int(dateFormat(which: 2, date: upTime.date))!

        if dateFormat(which: 0, date: now) == dateFormat(which: 0, date: upTime.date){
            //設定日が当日だった場合
            result_time = set_time - now_time
            if result_time >= 0{
                if result_time > 60{
                    rema_time.text = "\(result_time/60)時間\(result_time%60)分後です"
                    setting_time(rt: result_time)
                }else{
                    rema_time.text = "\(result_time)分後です"
                    setting_time(rt: result_time)
                }
            }else{
                rema_time.text = "時間が過ぎています"
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
                if result_time > 60{
                    rema_time.text = "\(result_time/60)時間\(result_time%60)分後です"
                    setting_time(rt: result_time)
                }else{
                    rema_time.text = "\(result_time)分後です"
                    setting_time(rt: result_time)
                }
            }else{
                rema_time.text = "日にちが過ぎています"
            }
        }
    }

    //設定時間処理
    func setting_time(rt:Int){
        let rtt = Date(timeInterval: TimeInterval(60*rt),since: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
        let resT = formatter.string(from: rtt)
        setTime.text = "\(resT)"
        
        db_send(set_time: result_time)
        Timer.scheduledTimer(timeInterval: 60,target: self,selector: #selector(self.timerUpdate),userInfo: nil,repeats: true)
    }
    
    @objc func timerUpdate(){
        result_time -= 1
        if result_time > 60{
            rema_time.text = "\(result_time/60)時間\(result_time%60)分後です"
        }else{
            rema_time.text = "\(result_time)分後です"
        }
    }
    
    
    //DBに送信
    func send_to_db(){
        let curtain_open:String = "1"  //開:1, 閉:0  ← 全体で共通の値
        let id:String = "1"  //レコードのid
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let updated_at = formatter.string(from: now)
        
        let url = "https://project-u.site:8000/location-php/api/saveCurtainStatus.php"
        guard let requestURL = URL(string:url) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postParameters1 = "curtain="+curtain_open+"&updated_at="+updated_at
        let postParameters = postParameters1+"&id="+id
        request.httpBody = postParameters.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return
            }
            do{
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = myJSON{
                    var msg : String!
                    msg = parseJSON["message"] as! String?
                    print("msg is \(msg)")
                }
            }catch{
                print("error2 is \(String(describing: error))")
            }
        }
        task.resume()
    }
    
    
    //ボタンクリック動作
    @IBAction func uptime_push(_ sender: UIButton) {
        let alert = UIAlertController(title:"時間設定",message:"起床時間の設定です",preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"時間を設定する",style:UIAlertActionStyle.default,handler:{
            (action: UIAlertAction!) in
            self.culcTime()
            
            // スリープ状態への移行を防ぐ
            UIApplication.shared.isIdleTimerDisabled = true
            
        })
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func db_send(set_time:Int) {
        var set_time = set_time
        set_time = set_time * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(set_time)){
            self.send_to_db()//ここにPHPの処理
            self.rema_time.text = "カーテンオープン"
            
            // スリープ状態への移行を防ぐ設定を解除する
            UIApplication.shared.isIdleTimerDisabled = false
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upTime.date = Date()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
