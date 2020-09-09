//
//  SelectLangViewController.swift
//  iWiDen New
//
//  Created by 山野智寛 on 2020/09/03.
//

import UIKit

class SelectLangViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var button: UILabel!
    
    var originlanguage : String?
    var originlanguagecode : String?
    // 翻訳したい言語類
    let dataList = [
            "日本語","英語","中国語","韓国語",
            "スペイン語","フランス語","ドイツ語","ロシア語"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        button.layer.shadowOpacity = 0.5  // 9
        button.layer.shadowRadius = 10  // 10
        button.layer.shadowColor = UIColor.gray.cgColor  
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        languageLabel.text = "言語を選択して下さい"
        
    }
    
    // UIPickerViewの列の数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // UIPickerViewの行数、リストの数
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            return dataList.count
        }
        
        // UIPickerViewの最初の表示
        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            
            return dataList[row]
        }
        
        // UIPickerViewのRowが選択された時の挙動
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            
            languageLabel.text = dataList[row]
            originlanguage = languageLabel.text
            if originlanguage == "日本語"{
                originlanguagecode = "ja"
            }else if originlanguagecode == "英語"{
                originlanguagecode = "en"
            }else if originlanguage == "中国語"{
                originlanguagecode = "zh"
            }else if originlanguage == "韓国語"{
                originlanguagecode = "ko"
            }else if originlanguage == "スペイン語"{
                originlanguagecode = "es"
            }else if originlanguage == "フランス語"{
                originlanguagecode = "fr"
            }else if originlanguage == "ドイツ語"{
                originlanguagecode = "de"
            }else if originlanguage == "ロシア語"{
                originlanguagecode = "ru"
            }
        }
    
    @IBAction func backButoon(_ sender: Any) {
        
        let preVC = self.presentingViewController as! ViewController
        preVC.languagecode = originlanguagecode ?? "en"
        //ここで値渡し
        
        dismiss(animated: true, completion: nil)
        
    }
    

}
