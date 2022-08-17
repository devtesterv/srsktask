

import UIKit
import PDFKit
import CoreData
class PreviewViewController: UIViewController {
    
    var getDatas = [String:Any]()
    public var documentData: Data?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateOfbrithLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
   
    @IBOutlet weak var signatureImg: UIImageView!
    @IBOutlet weak var pdfView: PDFView!
   
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
