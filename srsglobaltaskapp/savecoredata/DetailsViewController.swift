
import UIKit
import PDFKit
import CoreData

class DetailsViewController: UIViewController {
    
    var selectedProductName = ""
    var selectedProductUUID : UUID?
    
    @IBOutlet weak var signImageview: UIImageView!
    @IBOutlet weak var fnameLabel: UILabel!
    @IBOutlet weak var lnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        productSelection()
        // Do any additional setup after loading the view.
    }
    func productSelection() {
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
                            if let fname = result.value(forKey: "fname") as? String {
                                debugPrint(fname)
                                fnameLabel.text = fname
                            }
                            if let lname = result.value(forKey: "lname") as? String {
                                debugPrint(lname)
                                lnameLabel.text = lname
                            }
                            if let aged = result.value(forKey: "age") as? Int {
                                debugPrint(aged)
                                ageLabel.text = String(aged)
                            }
                            if let contactnos = result.value(forKey: "contactno") as? Int {
                                debugPrint(contactnos)
                                phonenumberLabel.text = String(contactnos)
                            }
                            if let imageData = result.value(forKey: "simage") as? Data {
                                let image = UIImage(data: imageData)
                                signImageview.image = image
                            }
                        }
                        
                    }
                }catch{
                    print("Error!")
                }
                
                
            }
        }else{
            fnameLabel.text = ""
            lnameLabel.text = ""
            ageLabel.text = ""
            phonenumberLabel.text = ""
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func sharePDF(_ sender: Any) {
        if let firstName = fnameLabel.text,
           let lastName = lnameLabel.text ,
           let image = signImageview.image,
           let dateOfbirth =  ageLabel.text,
           let phoneNo = phonenumberLabel.text{
            let pdfCreator = PDFCreator(firstName: firstName,
                                        lastName: lastName,
                                        image: image,
                                        dateOfbirth: dateOfbirth,
                                        phoneNumber: phoneNo)
            let pdfData = pdfCreator.createFlyer()
            let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
}
