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
    
    let nameMatrix = [
        ExpandableName(isExpanded: true, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]),
        ExpandableName(isExpanded: true, names: ["Carl", "Chris", "Christina", "Cameron"]),
        ExpandableName(isExpanded: true, names: ["David", "Dan"]),
        ExpandableName(isExpanded: true, names: ["Patrick", "Patty"]),
    ]
    
    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameMatrix[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let name = nameMatrix[indexPath.section].names[indexPath.row]
        
        if showIndexPaths {
            cell.textLabel?.text = "\(name)     Section: \(indexPath.section)    Row: \(indexPath.row)"
        } else {
            cell.textLabel?.text = name
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
            for row in nameMatrix[section].names.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        
        showIndexPaths = !showIndexPaths
        
        let anymationStyle = showIndexPaths ? UITableViewRowAnimation.left : .right
        
        tableView.reloadRows(at: indexPathsToReload, with: anymationStyle)
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Triying to expand or close.")
        
        let section = button.tag
        var indexPathsToDelete = [IndexPath]()
        
        for row in nameMatrix[0].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathsToDelete.append(indexPath)
        }
        
        tableView.deleteRows(at: indexPathsToDelete, with: .fade)
    }
}
