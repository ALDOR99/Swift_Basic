//
//  ViewController.swift
//  UserDefaultProject
//
//  Created by Ali Durna on 11.12.2023.
//

import UIKit

class ViewController: UIViewController {
     
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var zamanTextField: UITextField!
    
    @IBOutlet weak var notLabel: UILabel!
    @IBOutlet weak var zamanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoad: Uygulama yüklendiğinde çalışan metod
        
        // UserDefaults'tan kaydedilen not ve zaman bilgilerini al
        let kaydedilenNot = UserDefaults.standard.object(forKey: "not")
        let kaydedilenZaman = UserDefaults.standard.object(forKey: "zaman")
        
        // Eğer not bilgisi varsa, notLabel'a ekleyin
        if let gelenNot = kaydedilenNot as? String {
            notLabel.text = "Yapılacak iş : \(gelenNot)"
        }
        
        // Eğer zaman bilgisi varsa, zamanLabel'a ekleyin
        if let gelenZaman = kaydedilenZaman as? String {
            zamanLabel.text = "Yapılacak zaman : \(gelenZaman)"
        }
    }
        

    @IBAction func kaydetTiklandi(_ sender: Any) {
        // Kaydet butonuna tıklandığında çalışan metod
        
        // Kullanıcının girdiği not ve zaman bilgilerini UserDefaults'a kaydet
        UserDefaults.standard.set(noteTextField.text!, forKey: "not")
        UserDefaults.standard.set(zamanTextField.text!, forKey: "zaman")
        
        // notLabel ve zamanLabel'a güncellenmiş bilgileri ekleyin
        notLabel.text = "Yapılacak iş : \(noteTextField.text!)"
        zamanLabel.text = "Yapılacak zaman: \(zamanTextField.text!)"
    }
    
    @IBAction func silTiklandi(_ sender: Any) {
        // Sil butonuna tıklandığında çalışan metod
        
        // UserDefaults'tan kaydedilen not ve zaman bilgilerini al
        let kaydedilenNot = UserDefaults.standard.object(forKey: "not")
        let kaydedilenZaman = UserDefaults.standard.object(forKey: "zaman")
        
        // Eğer not bilgisi varsa, UserDefaults'tan sil ve notLabel'ı güncelle
        if (kaydedilenNot as? String) != nil {
            UserDefaults.standard.removeObject(forKey: "not")
            notLabel.text = "Yapılacak iş : "
        }
        
        // Eğer zaman bilgisi varsa, UserDefaults'tan sil ve zamanLabel'ı güncelle
        if (kaydedilenZaman as? String) != nil {
            UserDefaults.standard.removeObject(forKey: "zaman")
            zamanLabel.text = "Yapılacak zaman: "
        }
    }
}
