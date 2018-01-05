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

class SleepViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    var locationManager : CLLocationManager!
    
    @IBOutlet var accelerometerX: UILabel!
    @IBOutlet var accelerometerY: UILabel!
    @IBOutlet var accelerometerZ: UILabel!
    @IBOutlet weak var sleep_average: UILabel!
    
    var acceleX: Double = 0
    var acceleY: Double = 0
    var acceleZ: Double = 0
    var average: Double = 0
    let Alpha = 0.4
    var flg: Bool = false
    
    var sleepdate:[Double] = []
    var userPath:String!
    var number = 0
    
    func lowpassFilter(acceleration: CMAcceleration){
        acceleX = Alpha * acceleration.x + acceleX * (1.0 - Alpha)
        acceleY = Alpha * acceleration.y + acceleY * (1.0 - Alpha)
        acceleZ = Alpha * acceleration.z + acceleZ * (1.0 - Alpha)
        average = (acceleX + acceleY + acceleZ)/3
        
        accelerometerX.text = String(format: "%06f", acceleX)
        accelerometerY.text = String(format: "%06f", acceleY)
        accelerometerZ.text = String(format: "%06f", acceleZ)
        sleep_average.text = String(format: "%06f", average)
        sleepdate.append(average)
    }
    
    @IBAction func sleepstart(_ sender: UIButton) {
        motionManager.startAccelerometerUpdates(
            to: OperationQueue.current!,
            withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                self.lowpassFilter(acceleration: accelData!.acceleration)
        })
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func sleepstop(_ sender: UIButton) {
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
            userPath = NSHomeDirectory()+"/Documents/\(number).csv"
            let csvdate = sleepdate.description
            do{
                try csvdate.write(toFile: userPath,atomically: true,encoding: String.Encoding.utf8)
            }catch _ as NSError{
            }

        }
        sleepdate.removeAll()
        number += 1
        locationManager.stopUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if motionManager.isAccelerometerAvailable {
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ : CLLocation = locations.last!;
    }
    
    // 位置情報の取得に失敗すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
