//
//  ContactsList.swift
//  ContactsAPP
//
//  Created by Murali on 5/1/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import CoreData

var firstNameArray = [String]()
var surNameArray = [String]()
var mobileNOArray = [Int64]()
var emailIDArray = [String]()
var countryArray = [String]()
var contactDP = [UIImage]()

//var contactsArray:[NSManagedObject] = []

class ContactsList: UIViewController {
    
  
    
    @IBOutlet var contactsListTV: UITableView!
    
    var addContact:AddContact!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsListTV.tableFooterView = UIView.init(frame: .zero)
        contactsListTV.backgroundColor = #colorLiteral(red: 0.6084219403, green: 1, blue: 0.6925783085, alpha: 1)
        firstNameArray.sort()
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Contacts", in: moc)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataFetching()
        contactsListTV.reloadData()
    }
    
    
    @IBAction func onAddButtonTap(_ sender: Any)
    {
        addContact = self.storyboard?.instantiateViewController(withIdentifier: "AddContact") as! AddContact
        self.present(addContact, animated: true, completion: nil)
    }
    
    func dataFetching()
    {
        firstNameArray.removeAll()
        surNameArray.removeAll()
        mobileNOArray.removeAll()
        emailIDArray.removeAll()
        countryArray.removeAll()
        contactDP.removeAll()
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        do{
            var contactsArray = try moc.fetch(fetchReq)
            
           
            
            for i in 0..<contactsArray.count{
                let mo:NSManagedObject = contactsArray[i] as! NSManagedObject
                firstNameArray.append(mo.value(forKey: "firstname") as! String)
                surNameArray.append(mo.value(forKey: "surname") as! String)
                mobileNOArray.append(mo.value(forKey: "mobile") as! Int64)
                emailIDArray.append(mo.value(forKey: "email") as! String)
                countryArray.append(mo.value(forKey: "country") as! String)
                
                if let imageData = mo.value(forKey: "image")
                {
                    contactDP.append(UIImage(data: imageData as! Data)!)
                }
                
            }
            print(firstNameArray)
        }
        catch{
            print("Data Fetching Failed")
        }
    }
    
}

extension ContactsList : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstNameArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsListTV.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.name.text = "\(firstNameArray[indexPath.row]) \(surNameArray[indexPath.row])"
        cell.mobileNumber.text = "\(mobileNOArray[indexPath.row])"
        cell.displayImage.image =  contactDP[indexPath.row]
        cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.borderWidth = 2.5
        return cell
    }
    
    
}
