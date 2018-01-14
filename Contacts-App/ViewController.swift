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
    
    var nameMatrix = [
        ExpandableName(isExpanded: true, contacts: [FavoritableContact(name: "Amy", hasFavorited: false), FavoritableContact(name: "Bill", hasFavorited: false), FavoritableContact(name: "Zack", hasFavorited: false), FavoritableContact(name: "Steve", hasFavorited: false), FavoritableContact(name: "Jack", hasFavorited: false), FavoritableContact(name: "Jill", hasFavorited: false), FavoritableContact(name: "Mary", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [FavoritableContact(name: "Carl", hasFavorited: false), FavoritableContact(name: "Chris", hasFavorited: false), FavoritableContact(name: "Chirstina", hasFavorited: false), FavoritableContact(name: "Cameron", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [FavoritableContact(name: "David", hasFavorited: false), FavoritableContact(name: "Dan", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [FavoritableContact(name: "Patrick", hasFavorited: false), FavoritableContact(name: "Patty", hasFavorited: false)]),
        ]
    
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !nameMatrix[section].isExpanded {
            return 0
        }
        return nameMatrix[section].contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactCell
        cell.viewController = self
        
        let contact = nameMatrix[indexPath.section].contacts[indexPath.row]
        
        cell.accessoryView?.tintColor = contact.hasFavorited ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        if showIndexPaths {
            cell.textLabel?.text = "\(contact.name)     Section: \(indexPath.section)    Row: \(indexPath.row)"
        } else {
            cell.textLabel?.text = contact.name
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return nameMatrix.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Collapse", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
}

extension ViewController {
    
    @objc func handleShowIndexPath() {
        print("Attempting to show index path.")
        var indexPathsToReload = [IndexPath]()
        
        for section in nameMatrix.indices {
            if nameMatrix[section].isExpanded {
                for row in nameMatrix[section].contacts.indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPathsToReload.append(indexPath)
                }
            }
        }
        
        showIndexPaths = !showIndexPaths
        
        let anymationStyle = showIndexPaths ? UITableViewRowAnimation.left : .right
        
        tableView.reloadRows(at: indexPathsToReload, with: anymationStyle)
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        var indexPathsToMutate = [IndexPath]()
        
        for row in nameMatrix[section].contacts.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathsToMutate.append(indexPath)
        }
        
        let isExpanded = nameMatrix[section].isExpanded
        nameMatrix[section].isExpanded = !nameMatrix[section].isExpanded
        
        button.setTitle(nameMatrix[section].isExpanded ? "Collapse" : "Expand", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPathsToMutate, with: .fade)
        } else {
            tableView.insertRows(at: indexPathsToMutate, with: .fade)
        }
    }
}

extension ViewController {
    func favoriteTappedContact(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        nameMatrix[(indexPath.section)].contacts[(indexPath.row)].hasFavorited = !nameMatrix[indexPath.section].contacts[indexPath.row].hasFavorited
        
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
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritableContacts.append(FavoritableContact(name: contact.givenName + " " + contact.familyName, hasFavorited: false))
                    })
                    
                    let names = ExpandableName(isExpanded: true, contacts: favoritableContacts)
                    self.nameMatrix.append(names)
                } catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
                
            } else {
                print("Access denied.")
            }
        }
    }
}
