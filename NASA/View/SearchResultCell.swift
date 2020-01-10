//
//  SearchResultCell.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Cell used by Search Results Controller
class SearchResultCell: UITableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
