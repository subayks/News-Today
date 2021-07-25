//
//  DisplayNewsViewModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation
class DisplayNewsViewModel {
    var articleInfo: Articles?
    
    init( articleInfo: Articles) {
        self.articleInfo = articleInfo
    }
    
    func getUrl() ->String {
        return self.articleInfo?.url ?? ""
    }
    
    func getImageURL() ->String {
        return self.articleInfo?.urlToImage ?? ""
    }
    
    func getDiscription() ->String {
        return self.articleInfo?.description ?? ""
    }
}
