// ViewController.swift dosyası içindeki Sayaclar isimli proje
// Ali Durna tarafından 12.12.2023 tarihinde oluşturuldu.
import UIKit

// ViewController adında bir sınıf oluşturuluyor ve bu sınıf UIViewController sınıfından türetiliyor.
class ViewController: UIViewController {
    
    // IBOutlet özelliği ile Storyboard üzerindeki bir UILabel'ı bağlamak için kullanılır.
    @IBOutlet weak var label: UILabel!
    
    // Timer ve kalanZaman adında iki değişken tanımlanıyor.
    var timer = Timer()
    var kalanZaman = 0
    
    // UIViewController'ın yaşam döngüsü fonksiyonlarından biri olan viewDidLoad fonksiyonu.
    // Ekran yüklendiğinde çağrılır ve gerekli ayarlamalar yapılır.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Başlangıçta kalanZaman değişkeni 15 olarak ayarlanır.
        kalanZaman = 15
        
        // label öğesinin metin özelliği, "Zaman : \(kalanZaman)" olarak ayarlanır.
        label.text = "Zaman : \(kalanZaman)"
    }

    // Butona tıklandığında çağrılacak fonksiyon
    @IBAction func buttonTiklandi(_ sender: Any) {
        // Her saniyede bir çağrılacak şekilde timer başlatılır.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFonksiyonu), userInfo: nil, repeats: true)
    }
    
    // Timer tarafından her saniyede bir çağrılacak fonksiyon
    @objc func timerFonksiyonu() {
        // label'ın metin özelliği, "Zaman: \(kalanZaman)" olarak ayarlanır.
        label.text = "Zaman: \(kalanZaman)"
        
        // kalanZaman değişkeni bir azaltılır.
        kalanZaman -= 1
        
        // Eğer kalanZaman 0 ise
        if kalanZaman == 0 {
            // label'ın metin özelliği "Süre bitti" olarak ayarlanır.
            label.text = "Süre bitti"
            
            // Timer durdurulur.
            timer.invalidate()
            
            // kalanZaman tekrar 15 olarak ayarlanır.
            kalanZaman = 15
        }
    }
}

