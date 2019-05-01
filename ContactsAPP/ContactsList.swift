//
//  ContactsList.swift
//  ContactsAPP
//
//  Created by Murali on 5/1/19.
//  Copyright © 2019 Murali. All rights reserved.
//

import UIKit
import CoreData
class ContactsList: UIViewController {

    @IBOutlet var contactsListTV: UITableView!
    
    var addContact:AddContact!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsListTV.tableFooterView = UIView.init(frame: .zero)
        contactsListTV.backgroundColor = #colorLiteral(red: 0.6084219403, green: 1, blue: 0.6925783085, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onAddButtonTap(_ sender: Any)
    {
        addContact = self.storyboard?.instantiateViewController(withIdentifier: "AddContact") as! AddContact
        self.present(addContact, animated: true, completion: nil)
     }
    
}
