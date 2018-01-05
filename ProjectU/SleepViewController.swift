//
//  SleepViewController.swift
//  ProjectU
//
//  Created by Naoya on 2017/12/22.
//  Copyright © 2017年 osyou. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Darwin

class SleepViewController: UIViewController {
    //加速度と位置情報
    let motionManager = CMMotionManager()
    var locationManager : CLLocationManager!
    //ボタン類
    @IBOutlet var accelerometerX: UILabel!
    @IBOutlet var accelerometerY: UILabel!
    @IBOutlet var accelerometerZ: UILabel!
    @IBOutlet weak var sleep_average: UILabel!
    //３軸と平均、ローパスに使用する変数
    var acceleX: Double = 0
    var acceleY: Double = 0
    var acceleZ: Double = 0
    var average: String!
    let Alpha = 0.4
    var flg: Bool = false
    //sleepdateは後のcsvデータ
    var sleepdate:[[String]]=[[],[]]
    //csvファイル保存先
    var userPath:String!
    //現在時刻
    var now:String!
    //ファイルナンバー
    var number = 0
    
    //現在時刻取得
    func getNowTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmmss", options: 0, locale: Locale(identifier: "ja_JP"))
        now = formatter.string(from: Date())
    }
    //ローパスフィルター → テキスト出力,csvデータ出力
    func lowpassFilter(acceleration: CMAcceleration){
        //ローパスフィルター
        acceleX = Alpha * acceleration.x + acceleX * (1.0 - Alpha)
        acceleY = Alpha * acceleration.y + acceleY * (1.0 - Alpha)
        acceleZ = Alpha * acceleration.z + acceleZ * (1.0 - Alpha)
        //３軸の平均値
        average = String("\((acceleX + acceleY + acceleZ)/3)")
        //テキスト代入
        accelerometerX.text = String(format: "%06f", acceleX)
        accelerometerY.text = String(format: "%06f", acceleY)
        accelerometerZ.text = String(format: "%06f", acceleZ)
        sleep_average.text = average
        //現在時刻と平均値をcsvデータ配列に追加
        getNowTime()
        sleepdate[0].append(average)
        sleepdate[1].append(now)
    }
    //睡眠測定スタートボタン(BGで動かすのに同時に位置情報開始)
    @IBAction func sleepstart(_ sender: UIButton) {
        motionManager.startAccelerometerUpdates(
            to: OperationQueue.current!,
            withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                self.lowpassFilter(acceleration: accelData!.acceleration)
        })
        locationManager.startUpdatingLocation()
        self.view.backgroundColor = UIColor.red
    }
    //睡眠測定ストップボタン（終了と同時にcsvファイルに書き込み,位置情報終了）
    @IBAction func sleepstop(_ sender: UIButton) {
        self.view.backgroundColor = UIColor.white
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
            userPath = NSHomeDirectory()+"/Documents/(\(number)-\(now).csv"
            var csvdate:String = ""
            for singleArray in sleepdate{
                for singleString in singleArray{
                    csvdate += singleString
                    if singleString != singleArray[singleArray.count-1]{
                        csvdate += ","
                    }else{
                        csvdate += "\n"
                    }
                }
            }
            do{
                try csvdate.write(toFile: userPath,atomically: true,encoding: String.Encoding.utf8)
            }catch _ as NSError{
                //保存エラー。後でエラー表示を作ったら書く。
            }

        }
        //データを破棄からの初期化
        sleepdate.removeAll()
        sleepdate = [[],[]]
        number += 1
        locationManager.stopUpdatingLocation()
    }

    //位置情報のポップアップ用？※覚えてないから使う時が来たら調べて。
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ : CLLocation = locations.last!;
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    //とりあえず色々呼び出してるメインちゃん
    override func viewDidLoad() {
        super.viewDidLoad()
        if motionManager.isAccelerometerAvailable {
            //計測は8秒間隔
            motionManager.accelerometerUpdateInterval = 8
        }
        locationManager = CLLocationManager.init()
        locationManager.allowsBackgroundLocationUpdates = true;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self as? CLLocationManagerDelegate;
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined) {
            locationManager.requestAlwaysAuthorization();
        }
    }
    
    //アプリのメモリ不足警告。触るな危険。
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
