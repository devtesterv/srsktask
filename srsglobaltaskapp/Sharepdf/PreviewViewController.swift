

import UIKit
import PDFKit
import CoreData
class PreviewViewController: UIViewController {
    
    
    
    var selectedProductName = ""
    var selectedProductUUID : UUID?
    
    
        var getDatas = [String:Any]()
        public var documentData: Data?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateOfbrithLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var signatureImg: UIImageView!
    @IBOutlet weak var pdfView: PDFView!
    // MARK: - Property
    var imageS = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                signatureImg.image = imageS
                firstNameLabel.text = getDatas["One"] as! String
                lastNameLabel.text = getDatas["two"] as! String
                dateOfbrithLabel.text = getDatas["four"] as? String
                phoneNumberLabel.text = getDatas["five"] as! String
        
        
                if let data = documentData {
                  pdfView.document = PDFDocument(data: data)
                  pdfView.autoScales = true
                }
        productSelection()
    }
    func productSelection(){
        if selectedProductName != "" {
            if let uuidString = selectedProductUUID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveEntity")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "fname") as? String {
                                debugPrint(name)
                                //                                self.firstNameLabel.text = "Product: \(String(name)) )"
                            }
                            if let size = result.value(forKey: "lname") as? String {
                                debugPrint(size)
                                //                                lastNameLabel.text = "Size: \(String(size))"
                            }
                            if let price = result.value(forKey: "age") as? Int {
                                debugPrint(price)
                                //                                dateOfbrithLabel.text = "$\(String(price))"
                            }
                            if let imageData = result.value(forKey: "simage") as? Data {
                                let image = UIImage(data: imageData)
                                //                                self.signatureImg.image = image
                            }
                        }
                        
                    }
                }catch{
                    print("Error!")
                }
                
                
            }
        }
    }
    @IBAction func sharePDF(_ sender: Any) {
                        if let firstName = firstNameLabel.text,
                           let lastName = lastNameLabel.text,
                           let image = signatureImg.image,
                           let dateOfbirth = phoneNumberLabel.text,
                           let phoneNumber = getDatas["five"] {
                            let pdfCreator = PDFCreator(firstName: firstName,
                                                        lastName: lastName,
                                                        image: image,
                                                        dateOfbirth: dateOfbirth,
                                                        phoneNumber: phoneNumber as! String)
                            let pdfData = pdfCreator.createFlyer()
                            let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
                            present(vc, animated: true, completion: nil)
                        }
    }
}
