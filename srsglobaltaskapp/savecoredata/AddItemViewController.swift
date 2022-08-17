import UIKit
import CoreData
class AddItemViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfbirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet var signatureView: Canvas!
    @IBOutlet weak var signatureImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: Any){
        if let image = signatureView.getDesign {
            debugPrint(image)
            signatureImg.image = image
        }
        buttonDidPressed()
    }
    
    func buttonDidPressed() {
        if self.firstNameTextField.text!.isEmpty {
            showAlert(title: "First name", message: "Enter the first name")
        }else if self.lastNameTextField.text!.isEmpty {
            showAlert(title: "Last name", message: "Enter the last name")
        }else if self.dateOfbirthTextField.text!.isEmpty {
            showAlert(title: "DOB name", message: "Enter the DOB")
        }else if self.phoneNumberTextField.text!.isEmpty {
            showAlert(title: "Contact No", message: "Enter the Contact Number")
        }else{
            if let image = signatureView.getDesign {
                signatureImg.image = image
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let shopping = NSEntityDescription.insertNewObject(forEntityName: "SaveEntity", into: context)
            
            shopping.setValue(firstNameTextField.text ?? "", forKey: "fname")
            shopping.setValue(lastNameTextField.text ?? "", forKey: "lname")
            if let price = Int(dateOfbirthTextField.text!) {
                shopping.setValue(price, forKey: "age")
            }
            if let price = Int(phoneNumberTextField.text!) {
                shopping.setValue(price, forKey: "contactno")
            }
            shopping.setValue(UUID(), forKey: "id")
            
            let data = signatureImg.image?.jpegData(compressionQuality: 0.5)
            shopping.setValue(data, forKey: "simage")
            
            do{
                try context.save()
                print("saved")
            }catch{
                print("Error!")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
