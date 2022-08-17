//
//  AddItemViewController.swift
//  srsglobaltaskapp
//
//  Created by CV on 8/17/22.
//

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
