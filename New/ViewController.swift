//
//  ViewController.swift
//  iWiDen New
//
//  Created by 山野智寛 on 2020/09/03.
//

import UIKit
import CoreML
import Vision
import ROGoogleTranslate

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {

    var nextVC = NextViewController()
    var selectLang = SelectLangViewController()
    
    // 値渡しの変数
    var captureImage : UIImage?
    var jptranslation : String?
    var sendname : String?
    var translation : String?
    // var isModalBackflg = false

    @IBOutlet weak var targetView: UIImageView!
    @IBOutlet weak var selectLangButton: UIButton!
    @IBOutlet weak var Button: UIButton!
    
    // SelectLangからのlanguagecodeを格納する変数
    var languagecode : String = ""
    var language : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(targetView)
        
        selectLangButton.layer.cornerRadius = 10
        selectLangButton.layer.shadowOffset = CGSize(width: 3, height: 3 )
        selectLangButton.layer.shadowOpacity = 0.5
        selectLangButton.layer.shadowRadius = 10  // 10
        selectLangButton.layer.shadowColor = UIColor.gray.cgColor  // 11
        
        Button.layer.cornerRadius = 10  // 7
        Button.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        Button.layer.shadowOpacity = 0.5  // 9
        Button.layer.shadowRadius = 10  // 10
        Button.layer.shadowColor = UIColor.gray.cgColor  // 11
        
        
    }


    /*override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            if isModalBackflg {
                isModalBackflg = false
                modalBackMothod()
            }
        }
        // モーダルが閉じた後に実行されるメソッド
        func modalBackMothod() {
            textField.text = language
        }*/

    
    
    @IBAction func CameraButton(_ sender: Any) {
        
        // カメラかフォトライブラリーどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
    
    
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
               UIImagePickerController.SourceType.camera){
            // カメラを起動するための選択肢を定義
                let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action) in
                    // カメラを起動
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                alertController.addAction(cameraAction)
            }
            
        // フォトライブラリーが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // フォトライブラリーを起動するための選択肢を定義
            let photoLibraryAction = UIAlertAction(title: "アルバム", style: .default, handler: { (action) in
                // フォトライブラリーを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 選択肢を画面に表示
        present(alertController, animated: true, completion: nil)
        
       }
    
    // 画像認識による画像分析モデル
    func photoPredict(_ targetPhoto: UIImage){

    // 学習モデルのインスタンス生成
    guard let model = try? VNCoreMLModel(for: Resnet50().model) else{
        print("error model")
        return
    }

    // リクエスト
    let request = VNCoreMLRequest(model: model){
        request, error in
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        // 候補の１番目(英語)
        let name = results[0].identifier
        self.sendname = name
        
    }
            
    
    // 画像のリサイズ
    request.imageCropAndScaleOption = .centerCrop
            
    // CIImageに変換
    guard let ciImage = CIImage(image: targetPhoto) else {
        return
    }
            
    // 画像の向き
    let orientation = CGImagePropertyOrientation(
        rawValue: UInt32(targetPhoto.imageOrientation.rawValue))!
            
    // ハンドラを実行
    let handler = VNImageRequestHandler(
        ciImage: ciImage, orientation: orientation)
            
    do{
        try handler.perform([request])
                
    }catch {
        print("error handler")
        }
    }
    
    
    // 予測された単語を翻訳する
    func GTranslator(language:String, name:String){

    let params = ROGoogleTranslateParams(source: "en",
                                         target: language,
                                         text: name)
    let translator = ROGoogleTranslate()
    translator.apiKey = "MYKEY"
    translator.translate(params: params) { (result) in
        DispatchQueue.main.async {
            self.translation = "\(result)"
        }
    }
}
    
    // 予測された単語を日本語に変換する
    func JPGTranslator(name:String){

    let params = ROGoogleTranslateParams(source: "en",
                                         target: "ja",
                                         text: name)
    let translator = ROGoogleTranslate()
    translator.apiKey = "MYKEY"
    translator.translate(params: params) { (result) in
        DispatchQueue.main.async {
            self.jptranslation = "\(result)"
        }
    }
}
    
    
    
    
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        photoPredict(captureImage!)
        JPGTranslator(name: sendname ?? "エラーです")
        GTranslator(language: languagecode, name: sendname ?? "エラーです")
        
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "next", sender: nil)
        })
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
                // identifierが取れなかったら処理やめる
                return
            }
        if(identifier == "next") {
            let nc = segue.destination as! MyNavigationController
            let nextvc = nc.topViewController as! NextViewController
            nextvc.originalImage = captureImage
            nextvc.originalEnWord = sendname
            nextvc.originalWord = translation
            nextvc.originalJPWord = jptranslation
            nextvc.speechlanguage = languagecode
        
    }
    
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    

}

}
