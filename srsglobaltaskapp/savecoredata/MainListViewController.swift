//
//  AddViewController.swift
//  srsglobaltaskapp
//
//  Created by CV on 8/17/22.
//

import UIKit
import CoreData
class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var selectedProduct = ""
    var selectedID : UUID?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
    @IBAction func addNewClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddItemViewController")as! AddItemViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddItemViewController")as! AddItemViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Fetching datas from coredata
    @objc func fetchData(){
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "fname") as? String{
                        nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }
                }
                tableView.reloadData()
            }
            
        }catch {
            print("Error!")
        }
        
    }
    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListItemCell else { return UITableViewCell()}
        cell.namelabel.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewViewController") as! DetailsViewController
            
            self.selectedID = self.idArray[indexPath.row]
            self.selectedProduct = self.nameArray[indexPath.row]
            previewVC.selectedProductName = self.selectedProduct
            previewVC.selectedProductUUID = self.selectedID
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SaveEntity")
            fetchRequest.returnsObjectsAsFaults = false
            let uuidString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do{
                                    try context.save()
                                }catch{
                                    print("Error!")
                                }
                                break
                            }
                        }
                    }
                }
                
                
                
            }catch{
                print("Error!")
            }
            
        }
        
    }
    
}
