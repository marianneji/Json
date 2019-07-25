//
//  Petition.swift
//  Json
//
//  Created by Graphic Influence on 23/07/2019.
//  Copyright © 2019 marianne massé. All rights reserved.
//

import Foundation

struct Petition: Codable {
    
    var title: String
    var body: String
    var signatureCount: Int
}
