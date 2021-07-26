//
//  ArticlesListViewModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

class ArticlesListViewModel {
    var apiService: articleAPIServiceProtocol
    var articlesModel: ArticlesModel?
    var pageNo: Int = 1
    var selectedCountry: String?
    var selectedCategory: String?
    var sourceValue: String?
    var isSearchEnabled: Bool = false
    var searchText =  String()
    var loadingClosure:(()->())?
    var showAlert:((_ errorMessage: String?,_ errorTitle: String?) -> ())?
    var navigationClosure:(() ->())?
    var isLoading: Bool = false {
        didSet {
            self.loadingClosure?()
        }
    }
    
    init(articlesModel: ArticlesModel,selectedCountry: String,selectedCategory: String,sourceValue: String,apiService:articleAPIServiceProtocol = ApiServices()) {
        self.articlesModel = articlesModel
        self.selectedCategory = selectedCategory
        self.selectedCountry = selectedCountry
        self.sourceValue = sourceValue
        self.apiService = apiService
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
    
    //MARK:- Api call for Article list
    func makeApiCall() {
        let finalURL = self.getFinalUrl()
        
        if Reachability.isConnectedToNetwork() {
            self.isLoading = true
            
            apiService.getArticleResponse(finalURL: finalURL, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    if status == true {
                        self.isLoading = false
                        if self.isSearchEnabled {
                            self.articlesModel = result as? ArticlesModel
                        } else {
                            for item in (result as! ArticlesModel).articles ?? [] {
                                self.articlesModel?.articles?.append(item)
                            }
                        }
                        if self.articlesModel?.status == "error" {
                            self.showAlert?((result as! ArticlesModel).message ?? "", (result as! ArticlesModel).code ?? "")
                            return
                        }
                        self.navigationClosure?()
                        
                    } else {
                        self.showAlert?("No result found", "Note")
                        
                    }
                }
            })
        }
    }
    
    func getFinalUrl() ->String {
        return "https://newsapi.org/v2/top-headlines?country=\(self.selectedCountry ?? "")&category=\( (self.selectedCategory == "Select Category" ? "": self.selectedCategory) ?? "")&page=\(String(self.pageNo))&q=\(self.searchText)&sources=\(self.sourceValue ?? "")&apiKey=442339c823ba48be912e963c1271707b"
    }
}
