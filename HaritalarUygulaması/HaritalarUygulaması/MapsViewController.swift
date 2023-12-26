//  ViewController.swift
//  HaritalarUygulaması
//
//  Created by Ali Durna on 20.12.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var isimTextField: UITextField! // İsim girişi için metin alanı
    @IBOutlet weak var notTextField: UITextField! // Not girişi için metin alanı
    @IBOutlet weak var mapView: MKMapView! // Harita görünümü için IBOutlet tanımlanır.
    
    // MARK: - Properties
    
    var locationManager = CLLocationManager() // Cihaz konumunu yönetmek için kullanılan nesne
    var secilenLatitude = Double() // Seçilen konumun enlem bilgisi
    var secilenLongitude = Double() // Seçilen konumun boylam bilgisi
    
    var secilenIsim = "" // Düzenlenen veya görüntülenen yerin ismi
    var secilenId: UUID? // Düzenlenen veya görüntülenen yerin kimliği
    
    var annotationTitle = "" // Harita işaretinin başlığı
    var annotationSubTitle = "" // Harita işaretinin alt başlığı
    var annotationLatitude = Double() // Harita işaretinin enlem bilgisi
    var annotationLongitude = Double() // Harita işaretinin boylam bilgisi
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Görünüm yüklendikten sonra yapılması gereken ek işlemleri buraya ekleyebilirsiniz.
        
        // Harita görünümüne delegasyon atanır.
        mapView.delegate = self
        
        // Konum yöneticisinin delegasyonu ve doğruluk seviyesi ayarlanır.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Kullanıcıdan konum erişimi izni istenir.
        locationManager.requestWhenInUseAuthorization()
        
        // Konum güncellemeleri başlatılır.
        locationManager.startUpdatingLocation()
        
        // Haritada uzun basma (Long Press) tanıyıcısı eklenir.
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
        if secilenIsim != "" {
            // Core Data'dan verileri çek
            
            if let uuidString = secilenId?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchRequest)
                    if sonuclar.count > 0 {
                        for sonuc in sonuclar as! [NSManagedObject] {
                            if let isim = sonuc.value(forKey: "isim") as? String {
                                annotationTitle = isim
                                
                                if let not = sonuc.value(forKey: "not") as? String {
                                    annotationSubTitle = not
                                    
                                    if let latitude = sonuc.value(forKey: "latitude") as? Double {
                                        annotationLatitude = latitude
                                        
                                        if let longitude = sonuc.value(forKey: "longitude") as? Double {
                                            annotationLongitude = longitude
                                            
                                            let annotation = MKPointAnnotation()
                                            annotation.title = annotationTitle
                                            annotation.subtitle = annotationSubTitle
                                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                            annotation.coordinate = coordinate
                                            
                                            mapView.addAnnotation(annotation)
                                            isimTextField.text = annotationTitle
                                            notTextField.text = annotationSubTitle
                                            
                                            locationManager.stopUpdatingLocation()
                                            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                            let region = MKCoordinateRegion(center: coordinate, span: span )
                                            mapView.setRegion(region, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Hata: Core Data'dan veri çekme başarısız.")
                }
                
                // Yeni bir yer oluşturulduğunda bildirim gönderilir.
                NotificationCenter.default.post(name: NSNotification.Name("YeniYerOlusturuldu"), object: nil)
                navigationController?.popViewController(animated: true)
            }
        } else {
            // Yeni veriler eklendi
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Harita üzerindeki işaretin görünümü belirlenir.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "benimAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // Harita işaretinin detaylarında bulunan buton tıklandığında çağrılan fonksiyon.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if secilenIsim != "" {
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            
            // İşaretlenen konumun adres bilgisi alınır.
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placeMarkDizisi, hata in
                if let placeMarks = placeMarkDizisi {
                    if placeMarks.count > 0 {
                        let yeniPlacemark = MKPlacemark(placemark: placeMarks[0])
                        let item = MKMapItem(placemark: yeniPlacemark)
                        item.name = self.annotationTitle
                        
                        // Harita uygulamasında işaretlenen konuma yönlendirme yapılır.
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    // MARK: - Long Press Gesture
    
    // Haritada uzun basma (Long Press) ile konum seçildiğinde çağrılan fonksiyon.
    @objc func konumSec(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Uzun basılan noktanın harita koordinatlarına dönüştürülmesi.
            let dokunulanNokta = gestureRecognizer.location(in: mapView)
            let dokunulanKordinat = mapView.convert(dokunulanNokta, toCoordinateFrom: mapView)
            
            secilenLatitude = dokunulanKordinat.latitude
            secilenLongitude = dokunulanKordinat.longitude
            
            let annotation = MKPointAnnotation()
            
            // Seçilen konuma bir işaret eklenir.
            annotation.coordinate = dokunulanKordinat
            annotation.title = isimTextField.text
            annotation.subtitle = notTextField.text
            
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // Konum güncellendiğinde çağrılan fonksiyon.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if secilenIsim == "" {
            // Konum bilgileri alınıp, haritanın bu konuma odaklanması sağlanır.
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - IBActions
    
    // Kaydet butonuna tıklandığında çağrılan fonksiyon.
    @IBAction func kaydetTiklandi(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let yeniYer = NSEntityDescription.insertNewObject(forEntityName: "Yer", into: context)
        
        // Yeni yerin özellikleri atanır.
        yeniYer.setValue(isimTextField.text, forKey: "isim")
        yeniYer.setValue(notTextField.text, forKey: "not")
        yeniYer.setValue(secilenLatitude, forKey: "latitude")
        yeniYer.setValue(secilenLongitude, forKey: "longitude")
        yeniYer.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Kayıt edildi")
        } catch {
            print("Hata: Kayıt sırasında bir sorun oluştu.")
        }
    }
}
