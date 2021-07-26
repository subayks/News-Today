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
    let totalResults : Int?
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case totalResults = "totalResults"
        case message = "message"
        case code = "code"
        case sources = "sources"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        sources = try values.decodeIfPresent([Source].self, forKey: .sources)
    }
    
}
