//
//  ViewController.swift
//  srsglobaltaskapp
//
//  Created by CV on 8/17/22.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var signatureView: Canvas!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfbirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var signatureImg: UIImageView!
    var imageS = UIImage()
    var transferData = ["One","two","three","four","five"]as [Any]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
    }
    func setupViews(){
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
        scrollView.keyboardDismissMode = .onDrag
    }
    func shareAction() {
        // 1
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let dateOfbirth = dateOfbirthTextField.text,
            let phoneNumber = phoneNumberTextField.text
        else {
            // 2
            let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        if signatureView.isEmpty {
            let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        if let image = signatureView.getDesign {
            // 3
            let pdfCreator = PDFCreator(firstName: firstName, lastName: lastName, image: image, dateOfbirth: dateOfbirth, phoneNumber: phoneNumber)
            let pdfData = pdfCreator.createFlyer()
            
        }
    }
    @IBAction fileprivate func previewVCMethod(_ sender : UIButton) {
        
        let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewViewController
        if let image = signatureView.getDesign {
            debugPrint(image)
            previewVC.imageS = image
        }
        if let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let dateOfbirth = dateOfbirthTextField.text,
           let phoneNumber = phoneNumberTextField.text {
            let pdfCreator = PDFCreator(firstName: firstName, lastName: lastName, image: imageS, dateOfbirth: dateOfbirth, phoneNumber: phoneNumber)
                        let pdfData = pdfCreator.createFlyer()
                        previewVC.documentData = pdfCreator.createFlyer()
                        previewVC.getDatas["One"] = pdfCreator.firstName
                        previewVC.getDatas["two"] = pdfCreator.lastName
                        previewVC.getDatas["three"] = pdfCreator.image
                        previewVC.getDatas["four"] = pdfCreator.dateOfbirth
                        previewVC.getDatas["five"] = pdfCreator.phoneNumber
            
        }
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        
        signatureView.clear()
    }
    
}

