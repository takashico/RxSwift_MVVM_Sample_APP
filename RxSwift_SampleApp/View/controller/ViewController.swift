//
//  ViewController.swift
//  RxSwift_SampleApp
//
//  Created by Takahashi Shiko on 2020/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var areaSearchTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RxSwift Weather"
        
        areaSearchTextField.delegate = self
        areaSearchTextField.becomeFirstResponder()
        
        self.areaSearchTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .map { self.areaSearchTextField.text }
            .subscribe(onNext: { area in
                if let area = area, area.isEmpty == false {
                    self.fetchWeather(area: area)
                } else {
                    self.displayWeather(result: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    /// データ取得
    private func fetchWeather(area: String) {
        // 書き方1
//        CurrentWeatherRequest.fetchWeatherFromAreaName(area)
//            .observeOn(MainScheduler.instance)
//            .catchErrorJustReturn(WeatherResult.empty)
//            .subscribe(onNext: { result in
//                self.displayWeather(result: WeatherViewModel(result: result))
//            }).disposed(by: disposeBag)
        
        // 書き方2: 書き方1をDriverで書き換えた
        // Driverは、1. メインスレッド保証, 2. エラーを流さない
        CurrentWeatherRequest.fetchWeatherFromAreaName(area)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
            .drive(onNext: { result in
                self.displayWeather(result: WeatherViewModel(result: result))
            }).disposed(by: disposeBag)
    }
    
    /// データ表示
    private func displayWeather(result: WeatherViewModel?) {
        guard let result = result else {
            self.weatherLabel.text = "データ未取得"
            self.weatherIconImageView.isHidden = true
            self.tempLabel.text = nil
            return
        }
        
        // 天気
        result.weather.asDriver(onErrorJustReturn: "データ取得失敗")
            .drive(weatherLabel.rx.text)
            .disposed(by: disposeBag)
        // アイコン
        result.iconImage.asDriver(onErrorJustReturn: nil)
            .drive(onNext: { image in
            self.weatherIconImageView.isHidden = image == nil
            self.weatherIconImageView.image = image
        }).disposed(by: disposeBag)
        // 気温
        result.temp.asDriver(onErrorJustReturn: "")
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
