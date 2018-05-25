//
//  ViewController.swift
//  MyMap
//
//  Created by 島田智貴 on 2018/02/08.
//  Copyright © 2018年 hakusan-labo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Text Fieldのdelegate通知先を設定
    inputText.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var inputText: UITextField!
  
  @IBOutlet weak var dispMap: MKMapView!

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボード閉じる
    textField.resignFirstResponder()
    
    // 文字を取り出す
    let searchKeyword = textField.text
    
    // 文字をデバックエリアに表示
    print(searchKeyword)
    
    // CLGeocoderインスタンスを取得
    let geocoder = CLGeocoder()
    
    // 文字から位置情報を取得
    geocoder.geocodeAddressString(searchKeyword!, completionHandler: { (placemarks:[CLPlacemark]?, error:Error?) in
      // 位置情報が存在する場合１件目の位置情報を取り出す
      if let placemark = placemarks?[0] {
        // 位置情報から緯度経度が存在する場合、緯度経度をtargetCoordinateに取り出す
        if let targetCoordinate = placemark.location?.coordinate {
          // 緯度経度をデバックエリアに表示
          print(targetCoordinate)
          
          // ピンを生成
          let pin = MKPointAnnotation()
          
          // ピンの場所に緯度経度を設定
          pin.coordinate = targetCoordinate
          
          // ピンのタイトルを設定
          pin.title = searchKeyword
          
          // ピンを地図に置く
          self.dispMap.addAnnotation(pin)
          
          // 緯度経度を中心にして半径５００mの範囲を表示
          self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
        }
      }
    })
    
    return true
  }
  @IBAction func changeMapType(_ sender: Any) {
    switch dispMap.mapType {
    case .standard:
      dispMap.mapType = .satellite
    case .satellite:
      dispMap.mapType = .hybrid
    case .hybrid:
      dispMap.mapType = .satelliteFlyover
    case .satelliteFlyover:
      dispMap.mapType = .hybridFlyover
    default:
      dispMap.mapType = .standard
    }
  }
}

