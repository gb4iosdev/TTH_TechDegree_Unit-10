//
//  PendingOperations.swift
//  NASA
//
//  Created by Gavin Butler on 22-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Dictionary to track operations in progress using indexPath, and a download Queue to execute the operations.
class PendingOperations {
    
    var downloadsInProgress = [IndexPath : Operation]()
    let downloadQueue = OperationQueue()
}
