//
//  ViewViewController.swift
//  srsglobaltaskapp
//
//  Created by CV on 8/17/22.
//

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
                                fnameLabel.text = fname
                            }
                            if let lname = result.value(forKey: "lname") as? String {
                                lnameLabel.text = lname
                            }
                            if let aged = result.value(forKey: "age") as? Int {
                                ageLabel.text = String(aged)
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
    
}
