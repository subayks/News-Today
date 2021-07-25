//
//  SourceViewModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

class SourceViewModel {
    var articlesModel: ArticlesModel?
    var sourceValue: String?
    
    init(articlesModel: ArticlesModel) {
        self.articlesModel = articlesModel
    }
    
    func getSourceList(index: Int) ->String {
        return self.articlesModel?.articles?[index].source?.name ?? ""
        
    }
    
    func numberOfRows() ->Int {
        return self.articlesModel?.articles?.count ?? 0
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
                    self.articlesModel = values
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
    
    func updateSourceValue(index: Int) {
        self.sourceValue = self.articlesModel?.articles?[index].source?.id
    }
    
    func getFinalUrl() ->String {
        
        return "https://newsapi.org/v2/top-headlines?&source=\(self.sourceValue ?? "")&apiKey=32bf933974114bca8bef4f15db85a99c"
    }
    
    func viewModelForArtilceList() ->ArticlesListViewModel? {
           if let articlesModel = self.articlesModel {
               return ArticlesListViewModel.init(articlesModel: articlesModel,selectedCountry: "",selectedCategory: "" )
           }
           return ArticlesListViewModel(articlesModel: articlesModel!,selectedCountry: "",selectedCategory: "" )
       }
}
