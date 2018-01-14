//
//  ViewController.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let reuseIdentifier = "cellId"
    
    var nameMatrix = [
        ExpandableName(isExpanded: true, contacts: [Contact(name: "Amy", hasFavorited: false), Contact(name: "Bill", hasFavorited: false), Contact(name: "Zack", hasFavorited: false), Contact(name: "Steve", hasFavorited: false), Contact(name: "Jack", hasFavorited: false), Contact(name: "Jill", hasFavorited: false), Contact(name: "Mary", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [Contact(name: "Carl", hasFavorited: false), Contact(name: "Chris", hasFavorited: false), Contact(name: "Chirstina", hasFavorited: false), Contact(name: "Cameron", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [Contact(name: "David", hasFavorited: false), Contact(name: "Dan", hasFavorited: false)]),
        ExpandableName(isExpanded: true, contacts: [Contact(name: "Patrick", hasFavorited: false), Contact(name: "Patty", hasFavorited: false)]),
        ]
    
    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        button.setTitle("Close", for: .normal)
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
        
        button.setTitle(nameMatrix[section].isExpanded ? "Close" : "Open", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPathsToMutate, with: .fade)
        } else {
            tableView.insertRows(at: indexPathsToMutate, with: .fade)
        }
    }
}

extension ViewController {
    func favoriteTappedContact(cell: UITableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let contact = nameMatrix[(indexPath?.section)!].contacts[(indexPath?.row)!]
        nameMatrix[(indexPath?.section)!].contacts[(indexPath?.row)!].hasFavorited = !nameMatrix[(indexPath?.section)!].contacts[(indexPath?.row)!].hasFavorited
        print(contact.name, contact.hasFavorited)
    }
}
