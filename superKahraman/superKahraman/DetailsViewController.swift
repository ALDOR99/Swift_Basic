//
//  DetailsViewController.swift
//  superKahraman
//
//  Created by Ali Durna on 14.12.2023.
//
// DetailsViewController.swift dosyası

import UIKit

class DetailsViewController: UIViewController {
    // IBOutlet, storyboard veya xib dosyasındaki bir UI öğesini kod ile ilişkilendirmemizi sağlar.
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // Kullanıcının seçtiği kahramanın adını ve görsel ismini saklamak için değişkenler
    var secilenKahramanIsmi = ""
    var secilenKahramanGorseli = ""
    
    // View yüklendiğinde çağrılan metod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ImageView'a seçilen kahramanın görselini yükleme
        imageView.image = UIImage(named: secilenKahramanGorseli)
        
        // Label'a seçilen kahramanın adını yazma
        label.text = secilenKahramanIsmi
    }
}

