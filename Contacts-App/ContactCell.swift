//
//  ContactCell.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var viewController: ViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupFavoriteButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContactCell {
    fileprivate func setupFavoriteButton() {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        favoriteButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        favoriteButton.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
        accessoryView = favoriteButton
    }
}

extension ContactCell {
    @objc func handleFavoriteButton() {
        viewController?.favoriteTappedContact(cell: self)
    }
}
