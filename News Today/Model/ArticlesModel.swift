//
//  ArticlesModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

struct ArticlesModel: Codable {
    let status : String?
    let sources: [Source]?
    let totalResults : Int?
    var articles : [Articles]?
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
        case message = "message"
        case code = "code"
        case sources = "sources"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        articles = try values.decodeIfPresent([Articles].self, forKey: .articles)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        sources = try values.decodeIfPresent([Source].self, forKey: .sources)
    }
    
}

struct Articles : Codable {
    let source : Source?
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    
    enum CodingKeys: String, CodingKey {
        
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decodeIfPresent(Source.self, forKey: .source)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }
    
}

struct Source : Codable {
    let id : String?
    let name : String?
    let description: String?
    let url: String?
    let category: String?
    let language : String?
    let country: String?
        
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case description = "description"
        case url = "url"
        case category = "category"
        case language = "language"
        case country = "country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
    
}
