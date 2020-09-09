//
//  NextViewController.swift
//  iWiDen New
//
//  Created by 山野智寛 on 2020/09/03.
//

import UIKit
import Foundation
import AVFoundation

class NextViewController: UIViewController {

    
    var speechlanguage : String?
    var originalImage : UIImage?
    var originalWord : String?
    var originalJPWord : String?
    var originalEnWord : String?
    var EnArray : [String] = []
    
    // シンセサイザーを準備する
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var PhotoView: UIImageView!
    @IBOutlet weak var JPWordName: UILabel!
    @IBOutlet weak var WordName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        JPWordName.layer.masksToBounds = true
        JPWordName.layer.cornerRadius = 10
        JPWordName.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        JPWordName.layer.shadowOpacity = 0.5  // 9
        JPWordName.layer.shadowRadius = 10  // 10
        JPWordName.layer.shadowColor = UIColor.gray.cgColor
        
        WordName.layer.masksToBounds = true
        WordName.layer.cornerRadius = 10
        WordName.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        WordName.layer.shadowOpacity = 0.5  // 9
        WordName.layer.shadowRadius = 10  // 10
        WordName.layer.shadowColor = UIColor.gray.cgColor
        
        
        
        
        self.navigationItem.title = "予測結果"
        PhotoView.image = originalImage
        JPWordName.text = originalJPWord
        
        if speechlanguage == "en"{
            WordName.text = originalEnWord
        }else{
            WordName.text = originalWord
        }
        

        
        
        // 文字列が見つかった場合はrangeに範囲が代入される
        if originalEnWord!.range(of: ",") != nil {
            originalEnWord = originalEnWord!.components(separatedBy: ",")[0]
        } else {
            return
        }
        //self.view.sendSubviewToBack(backImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ナビゲーションバーのタイトルの文字色
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // ナビゲーションバーの背景の透過
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの下の影を無くす
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    
    // segueが動作することをViewControllerに通知するメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        
        
        if(identifier == "psSeque"){
            let ps = segue.destination as! PictureSearchViewController
            ps.searchword = self.originalEnWord!
        }else if(identifier == "dSeque"){
            let d = segue.destination as! DictonaryViewController
            d.dictionaryword = self.originalEnWord!
        }
       /* // segueのIDを確認して特定のsegueのときのみ動作させる
        if(identifier == "ncSegue") {
            
            // segueから遷移先のNavigationControllerを取得
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! MakeMylistViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストを入れる
            vc.mylistword = self.WordName.text ?? "エラーが起きています"
        }*/
        
        
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pronunciationButton(_ sender: Any) {
        
        guard let text = WordName.text else {
                    return
                }
        // 話す内容をセット
        let utterance = AVSpeechUtterance(string: text)
        // 言語を選択された言語に設定
        utterance.voice = AVSpeechSynthesisVoice(language: speechlanguage)
        // 実行
        self.synthesizer.speak(utterance)
    
        
    }
    
    @IBAction func mylistButton(_ sender: Any) {
        //コンテキスト開始
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
        //viewを書き出す
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        // imageにコンテキストの内容を書き出す
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //コンテキストを閉じる
        UIGraphicsEndImageContext()
        // imageをカメラロールに保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        
    }
    
    @IBAction func pictureSearchButton(_ sender: Any) {
        performSegue(withIdentifier: "psSeque", sender: nil)
    }
    
    @IBAction func dictionaryButton(_ sender: Any) {
        performSegue(withIdentifier: "dSeque", sender: nil)
    }
    
    
}
