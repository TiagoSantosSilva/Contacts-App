//
//  ViewControllerTableViewExtension.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !nameList[section].isExpanded {
            return 0
        }
        return nameList[section].contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.viewController = self
        
        let favoritableContact = nameList[indexPath.section].contacts[indexPath.row]
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        let favoritableContactContent = "\(favoritableContact.contact.givenName) \(favoritableContact.contact.familyName)"
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        if showIndexPaths {
            cell.textLabel?.text = "\(favoritableContactContent)     Section: \(indexPath.section)    Row: \(indexPath.row)"
        } else {
            cell.textLabel?.text = favoritableContactContent
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return nameList.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Collapse", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
}
