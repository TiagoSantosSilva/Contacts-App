//
//  ViewControllerHandlersExtension.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

extension ViewController {
    
    @objc func handleShowIndexPath() {
        var indexPathsToReload = [IndexPath]()
        
        for section in nameList.indices {
            if nameList[section].isExpanded {
                for row in nameList[section].contacts.indices {
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
        
        for row in nameList[section].contacts.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathsToMutate.append(indexPath)
        }
        
        let isExpanded = nameList[section].isExpanded
        nameList[section].isExpanded = !nameList[section].isExpanded
        
        button.setTitle(nameList[section].isExpanded ? "Collapse" : "Expand", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPathsToMutate, with: .fade)
        } else {
            tableView.insertRows(at: indexPathsToMutate, with: .fade)
        }
    }
}
