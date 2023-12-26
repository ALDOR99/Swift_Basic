//
//  ListViewController.swift
//  HaritalarUygulaması
//
//  Created by Ali Durna on 24.12.2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView! // UITableView için IBOutlet tanımlanır.
    
    // MARK: - Properties
    
    var isimDizisi = [String]() // Yer isimlerini tutan dizi
    var idDizisi = [UUID]() // Yer kimliklerini tutan dizi
    
    var secilenYerIsmi = "" // Seçilen yerin ismi
    var secilenYerId: UUID? // Seçilen yerin kimliği
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Sağ üst köşede "Ekle" butonu eklenir.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(artiButtonTiklandi))
        
        // Verileri ekrana yükle
        veriAl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Yeni bir yer oluşturulduğunda bildirim alınır.
        NotificationCenter.default.addObserver(self, selector: #selector(veriAl), name: NSNotification.Name("YeniYerOlusturuldu"), object: nil)
    }
    
    // MARK: - Veri İşleme
    
    @objc func veriAl() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
        
        do {
            let sonuclar = try context.fetch(request)
            if sonuclar.count > 0 {
                
                // Diziler temizlenir.
                isimDizisi.removeAll(keepingCapacity: false)
                idDizisi.removeAll(keepingCapacity: false)
                
                // Core Data'dan alınan veriler diziye eklenir.
                for sonuc in sonuclar as! [NSManagedObject] {
                    if let isim = sonuc.value(forKey: "isim") as? String {
                        isimDizisi.append(isim)
                    }
                    if let id = sonuc.value(forKey: "id") as? UUID {
                        idDizisi.append(id)
                    }
                }
                
                // TableView güncellenir.
                tableView.reloadData()
            }
        } catch {
            print("Hata: Core Data'dan veri çekme başarısız.")
        }
    }
    
    // MARK: - IBActions
    
    // "Ekle" butonuna tıklandığında çağrılan fonksiyon.
    @objc func artiButtonTiklandi() {
        // Seçilen yer ismi sıfırlanır.
        secilenYerIsmi = ""
        
        // Harita ekranına geçiş yapılır.
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    // MARK: - UITableView Delegate ve DataSource
    
    // TableView'daki satır sayısını belirten fonksiyon.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    
    // TableView'daki hücreleri oluşturan fonksiyon.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
    }
    
    // TableView'daki bir satıra tıklandığında çağrılan fonksiyon.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen yerin ismi ve kimliği alınır.
        secilenYerIsmi = isimDizisi[indexPath.row]
        secilenYerId = idDizisi[indexPath.row]
        
        // Harita ekranına geçiş yapılır.
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    // MARK: - Navigation
    
    // Geçiş öncesi veri hazırlıkları.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsVC" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.secilenIsim = secilenYerIsmi
            destinationVC.secilenId = secilenYerId
        }
    }
}

