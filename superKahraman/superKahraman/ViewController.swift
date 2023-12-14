//
//  ViewController.swift
//  superKahraman
//
//  Created by Ali Durna on 13.12.2023.
//
// ViewController.swift dosyası

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // IBOutlet, storyboard veya xib dosyasındaki bir UI öğesini kod ile ilişkilendirmemizi sağlar.
    @IBOutlet weak var tableView: UITableView!

    // Süper kahraman isimlerini ve görsel isimlerini tutacak diziler
    var superKahramanIsimleri = [String]()
    var superKahramanGorselIsimleri = [String]()

    // Kullanıcının seçtiği isim ve görseli saklamak için değişkenler
    var secilenIsim = ""
    var secilenGorsel = ""
    
    // View yüklendiğinde çağrılan metod
    override func viewDidLoad() {
        super.viewDidLoad()

        // UITableView için delegate ve dataSource'ı ViewController sınıfına atıyoruz.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Süper kahraman isimlerini diziye ekliyoruz
        superKahramanIsimleri.append("Banner")
        superKahramanIsimleri.append("Logan")
        superKahramanIsimleri.append("Osborn")
        superKahramanIsimleri.append("Peter")
        superKahramanIsimleri.append("Stark")
        
        // Süper kahraman görsel isimlerini diziye ekliyoruz
        superKahramanGorselIsimleri.append("banner")
        superKahramanGorselIsimleri.append("logan")
        superKahramanGorselIsimleri.append("osborn")
        superKahramanGorselIsimleri.append("peter")
        superKahramanGorselIsimleri.append("stark")
    }

    // UITableViewDataSource Protokolü'nden gelen metod: Kaç tane hücre olacağını belirler.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superKahramanIsimleri.count
    }

    // UITableViewDataSource Protokolü'nden gelen metod: Her bir hücreyi oluşturur ve içeriğini belirler.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // UITableViewCell nesnesi oluşturuluyor.
        let cell = UITableViewCell()
        
        // Hücrenin içeriği belirleniyor. Burada her hücrede "Test" metni gösterilecek.
        cell.textLabel?.text = superKahramanIsimleri[indexPath.row]
        
        return cell // Oluşturulan hücre geri döndürülüyor.
    }
    
    // Bir hücreyi silmek için çağrılan metod
    func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete {
            // Silme işlemi gerçekleşiyor
            superKahramanGorselIsimleri.remove(at: indexPath.row)
            superKahramanIsimleri.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }

    // Bir hücreye tıklandığında çağrılan metod
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen hücrenin bilgileri saklanıyor
        secilenIsim = superKahramanIsimleri[indexPath.row]
        secilenGorsel = superKahramanGorselIsimleri[indexPath.row]
        
        // Segue işlemi gerçekleştiriliyor
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    // Segue geçişinden önce çağrılan metod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            // Hedef ViewController'a veri aktarılıyor
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenKahramanIsmi = secilenIsim
            destinationVC.secilenKahramanGorseli = secilenGorsel
        }
    }
}
