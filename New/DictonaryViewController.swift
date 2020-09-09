//
//  DictonaryViewController.swift
//  iWiDen New
//
//  Created by 山野智寛 on 2020/09/03.
//

import UIKit
import WebKit

class DictonaryViewController: UIViewController {

    var dictionaryword = String()
    var DictArray = [String]()
    
    @IBOutlet weak var WebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲージョンアイテムの文字色
            self.navigationController!.navigationBar.tintColor = UIColor.white
            // ナビゲーションバーのタイトルの文字色
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            // ナビゲーションバーの背景色
            self.navigationController!.navigationBar.barTintColor = UIColor(red: 80/255, green: 204/255, blue: 240/255, alpha: 100)
            // ナビゲーションバーの背景の非透過
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController!.navigationBar.shadowImage = nil
            // ナビゲーションバーの下の影を無くす
            self.navigationController!.navigationBar.shadowImage = UIImage()
        
        
        
        if let range = dictionaryword.range(of: " ") {
            DictArray = dictionaryword.components(separatedBy: " ")
            dictionaryword = DictArray[0] + "+" + DictArray[1]
        } else {
            return
        }

        if let url = URL(string: "https://ejje.weblio.jp/content/\(dictionaryword)") {  // URL文字列の表記間違いなどで、URL()がnilになる場合があるため、nilにならない場合のみ以下のload()が実行されるようにしている
            self.WebView.load(URLRequest(url: url))
          }
        }
    
}
    


