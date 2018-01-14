//
//  ExpandableName.swift
//  Contacts-App
//
//  Created by Tiago Santos on 14/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import Foundation

struct ExpandableName {
    var isExpanded: Bool
    var contacts: [FavoritableContact]
}

struct FavoritableContact {
    let name: String
    var hasFavorited: Bool
}
