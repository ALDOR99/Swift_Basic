//
//  DetailsViewController.swift
//  sehirTanitimKitabi
//
//  Created by Ali Durna on 17.12.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sehirIsmiLabel: UILabel!
    @IBOutlet weak var sehirBolgeLabel: UILabel!
    
    var secilenSehir :Sehir?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sehirIsmiLabel.text = secilenSehir?.isim
        sehirBolgeLabel.text = secilenSehir?.bolge
        imageView.image = secilenSehir?.gorsel
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
