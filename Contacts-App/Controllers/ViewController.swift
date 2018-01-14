//
//  ViewController.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let reuseIdentifier = "cellId"
    
    var nameList = [ExpandableName]()
    
    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        setupNavigationBar()
        tableView.register(ContactCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ViewController {
    func favoriteTappedContact(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        nameList[(indexPath.section)].contacts[(indexPath.row)].hasFavorited = !nameList[indexPath.section].contacts[indexPath.row].hasFavorited
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Failed to request access: ", error)
                return
            }
            
            if granted {
                print("Access granted.")
                
                var favoritableContacts = [FavoritableContact]()
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                    })
                    
                    let names = ExpandableName(isExpanded: true, contacts: favoritableContacts)
                    self.nameList.append(names)
                } catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
                
            } else {
                print("Access denied.")
            }
        }
    }
}
