//
//  AddContact.swift
//  ContactsAPP
//
//  Created by Murali on 5/1/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import CoreData
var moc:NSManagedObjectContext!
 var entity:NSEntityDescription!
class AddContact: UIViewController {
    
    @IBOutlet var contactFirstNameTF: UITextField!
    @IBOutlet var contactSurnameTF: UITextField!
    @IBOutlet var contactMobileNOTF: UITextField!
    @IBOutlet var contactEmailIDTF: UITextField!
    @IBOutlet var contactCountryTF: UITextField!
    @IBOutlet var contactImage: UIImageView!
    
    var listOfCountries:[String]!
    
    var imagePicker = UIImagePickerController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        countryList()
        createPickerView()
        createToolbar()
        tapGesture()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    @IBAction func onCancekButtonTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSaveButtonTap(_ sender: UIBarButtonItem) {
        
        entity = NSEntityDescription.entity(forEntityName: "Contacts", in: moc)
        
        var mo = NSManagedObject(entity: entity, insertInto: moc)
        mo.setValue(contactFirstNameTF.text, forKey: "firstname")
        mo.setValue(contactSurnameTF.text, forKey: "surname")
        mo.setValue(Int64(contactMobileNOTF.text!), forKey: "mobile")
        mo.setValue(contactEmailIDTF.text, forKey: "email")
        mo.setValue(contactCountryTF.text, forKey: "country")
        if let contactPic = contactImage.image?.jpegData(compressionQuality: 1.0){
            mo.setValue(contactPic, forKey: "image")
            print("Image Is saved")
        }
        do{
            try moc.save()
            print("Data is Saved TO CoreData")
        }
        catch{
            print("Something Went Wrong")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension AddContact : UITextFieldDelegate{

}

extension AddContact : UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func tapGesture()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapImage(sender:)))
        contactImage.addGestureRecognizer(tap)
        contactImage.isUserInteractionEnabled = true
    }
    @objc func onTapImage(sender:UITapGestureRecognizer)
    {
        if sender.view as? UIImageView != nil
        {
            imagePickerActionSheet()
        }
    }
    func imagePickerActionSheet(){
        let options = UIAlertController(title: nil, message: "Choose From", preferredStyle: UIAlertController.Style.actionSheet)
        let saveAction = UIAlertAction(title: "Add From Library", style: UIAlertAction.Style.default) { (alertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Add From Camera", style: UIAlertAction.Style.default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
            } else {
                noCamera()
            }
        }
        
        func noCamera(){
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.destructive) { (alert: UIAlertAction!) -> Void in
            
        }
        options.addAction(saveAction)
        options.addAction(deleteAction)
        options.addAction(cancelAction)
        self.present(options, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            contactImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddContact : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func createPickerView()
    {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        contactCountryTF.inputView = picker
    }
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        contactCountryTF.inputAccessoryView = toolBar
        
    }
    @objc func dismissKeyboard() {
        contactCountryTF.resignFirstResponder()
        
        view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCountries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        
    {
            contactCountryTF.text = listOfCountries[row]
    }
    func countryList()
    {
        listOfCountries = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]
    }
    
    
}
