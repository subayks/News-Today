//
//  SourceModel.swift
//  News Today
//
//  Created by Subendran on 26/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation
struct SourceModel: Codable {
    let status : String?
    let sources: [Source]?
   
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case sources = "sources"
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sources = try values.decodeIfPresent([Source].self, forKey: .sources)
    }
    
}
