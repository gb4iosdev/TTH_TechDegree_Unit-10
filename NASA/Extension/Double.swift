//
//  Double.swift
//  NASA
//
//  Created by Gavin Butler on 29-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

extension Double {
    
    //Convert to a percentage with max 2 decimal places
    func asPercent() -> String {
        let percentage = self * 100.0
        return String(format: "%.1f", percentage) + "%"
    }
}
