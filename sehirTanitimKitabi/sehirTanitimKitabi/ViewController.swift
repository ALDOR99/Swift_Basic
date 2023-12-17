//
//  ViewController.swift
//  sehirTanitimKitabi
//
//  Created by Ali Durna on 17.12.2023.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var viewTable: UITableView!
    
    var sehirDizisi = [Sehir]()
    var KullaniciSecimi : Sehir?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewTable.delegate = self
        viewTable.dataSource = self
        
        //Şehirler
        
        let istanbul = Sehir(isim: "İstanbul", bolge: "Marmara", gorsel: UIImage(named:"istanbul")!)
        let ankara = Sehir(isim: "Ankara", bolge: "İç Anadolu", gorsel: UIImage(named:"ankara")!)
        let antalya = Sehir(isim: "Antalya", bolge: "Ege", gorsel: UIImage(named:"antalya")!)
        let diyarbakir = Sehir(isim: "Diyarbakır", bolge: "Güneydoğu Anadolu", gorsel: UIImage(named:"diyarbakir")!)
        let adana = Sehir(isim: "Adana", bolge: "Güneydoğu", gorsel: UIImage(named:"adana")!)
        sehirDizisi = [istanbul,ankara,antalya,diyarbakir,adana]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sehirDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sehirDizisi[indexPath.row].isim
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        KullaniciSecimi = sehirDizisi[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenSehir = KullaniciSecimi
        }
    }
}

