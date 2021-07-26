//
//  SourceViewModel.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

class SourceViewModel {
    var apiService: articleAPIServiceProtocol
    var articlesModel: ArticlesModel?
    var sourceValue: String?
    var loadingClosure:(()->())?
    var showAlert:(() -> ())?
    var navigationClosure:(() ->())?
    var reloadClosure:(() ->())?

    
    var isLoading: Bool = false {
        didSet {
            self.loadingClosure?()
        }
    }
    var countryListArray = [String]()
    var categoryArray = [String]()
    var languageArray = [String]()
    var selectedCountry: String?
    var selectedCategory: String?
    var selectedLanguage: String?
    var channelSelected: Bool = false
    
    init(articlesModel: ArticlesModel, apiService:articleAPIServiceProtocol = ApiServices()) {
        self.apiService = apiService
        self.articlesModel = articlesModel
    }
    
    func setUpCountryList() {
        countryListArray.append("All")
        self.selectedCountry = self.countryListArray[0]
        if let sources = self.articlesModel?.sources {
            for item in sources {
                countryListArray.append(item.country ?? "")
            }
        }
    }
    
    func setUplanguageArray() {
        languageArray.append("All")
        self.selectedLanguage = self.languageArray[0]
        if let sources = self.articlesModel?.sources {
            for item in sources {
                languageArray.append(item.language ?? "")
            }
        }
    }
    
    func setUpCategoryArray() {
      categoryArray =  ["All","Business", "Entertainment", "General", "Health", "Science","Technology"]
        self.selectedCategory = categoryArray[0]
    }
    
    func updateSelectedCategory(category: String) {
        self.selectedCategory = category
        makeApiCall()
    }
    
    func updateSelectedCountry(country: String) {
        self.selectedCountry = country
        makeApiCall()
    }
    
    func updateSelectedLanguage(language: String) {
        self.selectedLanguage = language
        makeApiCall()
    }
    
    
    func makeApiCall() {
        let finalURL = self.getFinalUrl()
        
        if Reachability.isConnectedToNetwork() {
            self.isLoading = true
            
            apiService.getArticleResponse(finalURL: finalURL, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    if status == true {
                        self.articlesModel = result as? ArticlesModel
                        self.isLoading = false
                        if self.articlesModel?.status == "error" {
                            self.showAlert?()
                            return
                        }
                        if self.channelSelected {
                        self.navigationClosure?()
                        } else {
                            self.reloadClosure?()
                        }
                        
                    } else {
                        self.showAlert?()
                        
                    }
                }
            })
        }
    }
    
    func getSourceList(index: Int) ->String {
        return self.articlesModel?.sources?[index].name ?? ""
        
    }
    
    func numberOfRows() ->Int {
        return (self.articlesModel?.sources?.count ?? 0) == 0 ? 1: (self.articlesModel?.sources?.count ?? 0)
    }
    
    func updateSourceValue(index: Int) {
        self.sourceValue = self.articlesModel?.sources?[index].id
    }
    
    func getFinalUrl() ->String {
        if channelSelected {
        return "https://newsapi.org/v2/top-headlines?sources=\(self.sourceValue ?? "")&apiKey=b5177be3e6ad4286b6dbc3d83421efd7"
        } else {
            return "https://newsapi.org/v2/top-headlines/sources?language=\((self.selectedLanguage == "All" ? "" : self.selectedLanguage) ?? "")&category=\((self.selectedCategory == "All" ? "" : self.selectedCategory)  ?? "")&country=\((self.selectedCountry == "All" ? "" :self.selectedCountry) ?? "")&apiKey=b5177be3e6ad4286b6dbc3d83421efd7"
        }
    }
    
    func viewModelForArtilceList() ->ArticlesListViewModel? {
        if let articlesModel = self.articlesModel {
            return ArticlesListViewModel.init(articlesModel: articlesModel,selectedCountry: "",selectedCategory: "", sourceValue: self.sourceValue ?? "" )
        }
        return ArticlesListViewModel(articlesModel: articlesModel!,selectedCountry: "",selectedCategory: "", sourceValue: self.sourceValue ?? "" )
    }
}
