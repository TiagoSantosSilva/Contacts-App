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
    
    let names = ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]
    let cNames = ["Carl", "Chris", "Christina", "Cameron"]
    let dNames = ["David", "Dan"]
    
    let nameMatrix = [
    ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"],
    ["Carl", "Chris", "Christina", "Cameron"],
    ["David", "Dan"],
    ["Patrick", "Patty"]
    ]
    
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
        return nameMatrix[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let name = nameMatrix[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return nameMatrix.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        label.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        return label
    }
}

extension ViewController {
    @objc func handleShowIndexPath() {
        print("Attempting to show index path.")
        var indexPathsToReload = [IndexPath]()
        
        for section in nameMatrix.indices {
            for index in nameMatrix[section].indices {
                let indexPath = IndexPath(row: index, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        tableView.reloadRows(at: indexPathsToReload, with: .left)
    }
}
