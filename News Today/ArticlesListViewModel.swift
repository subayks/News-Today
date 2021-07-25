//
//  ArticlesListViewModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

class ArticlesListViewModel {
    var articlesModel: ArticlesModel?
    var pageNo: Int = 1
    var selectedCountry: String?
    var selectedCategory: String?
    var isSearchEnabled: Bool = false
    var searchText =  String()
    
    init(articlesModel: ArticlesModel,selectedCountry: String,selectedCategory: String) {
        self.articlesModel = articlesModel
        self.selectedCategory = selectedCategory
        self.selectedCountry = selectedCountry
    }
    
    func numberofRows() ->Int {
        return self.articlesModel?.articles?.count ?? 1
    }
    
    func getArticleInfo(index: Int) ->Articles? {
        if let articleInfo = self.articlesModel?.articles?[index] {
            return  articleInfo
        }
        return nil
    }
    
    func viewmodelForDisplayNewsViewModel(index: Int) ->DisplayNewsViewModel? {
        if let articleInfo = self.articlesModel?.articles?[index] {
            return DisplayNewsViewModel.init(articleInfo: articleInfo)
        }
        return DisplayNewsViewModel.init(articleInfo: (self.articlesModel?.articles?[index])!)
    }
    
    func getArticleResponse(withBaseURl finalURL: String, withParameters parameters: String, completionHandler: @escaping (Bool, String?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   parameters, withHttpMethod: "GET", withContentType: "application/hal+json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completionHandler(false, error , errorCode)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    let values = try! decoder.decode(ArticlesModel.self, from: result!)
                    if self.isSearchEnabled {
                        self.articlesModel = values
                    } else {
                        for item in values.articles ?? [] {
                            self.articlesModel?.articles?.append(item)
                        }
                    }
                    if values.status == "error" {
                        completionHandler(false, values.message, values.code)
                    }
                    completionHandler(true, error, errorCode)
                    
                } catch let error as NSError {
                    //do something with error
                    completionHandler(false, error.localizedDescription, errorCode)
                }
                
            }
        }
        )}
    
    func getFinalUrl() ->String {
        
        return "https://newsapi.org/v2/top-headlines?country=\(self.selectedCountry ?? "")&category=\( (self.selectedCategory == "Select Category" ? "": self.selectedCategory) ?? "")&page=\(String(self.pageNo))&q=\(self.searchText)&apiKey=32bf933974114bca8bef4f15db85a99c"
    }
}
