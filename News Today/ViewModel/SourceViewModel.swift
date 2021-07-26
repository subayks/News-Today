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
    var sourceModel: SourceModel?
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
    var countryListArray = [CountryModel]()
    var categoryArray = [String]()
    var languageArray = [LanguageModel]()
    var selectedCountry: CountryModel?
    var selectedCategory: String?
    var selectedLanguage: LanguageModel?
    
    var countryNameArray = ["All","United Arab Emirates","Argentina","Austria","Australia","Belgium","Bulgaria","Brazil","Canada","Switzerland","China","Colombia","Cuba","Czechia","Germany","Egypt","France","United Kingdom of Great Britain and Northern Ireland","Greece","Hong Kong","Hungary","Indonesia","Ireland","Israel"," India","Italy","Japan","Korea","Lithuania","Latvia","Morocco","Mexico","Malaysia","Nigeria","Netherlands","Norway","New Zealand","Philippines","Poland","Portugal","Romania","Serbia","Russian","Saudi Arabia","Sweden","Singapore","Slovenia","Slovakia","Thailand","Turkey","Taiwan","Ukraine","United States of America","Venezuela","South Africa"]
    
    var countryCode = ["","ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za"]
    
    var languageCode = ["","ar","de","en","es","fr","he","it","nl","no","pt","ru","se","ud","zh"]
    var languageNameList = ["All","Arabic","German","English","Spanish","French","Hebrew","Italian","Dutch","Norwegian","Portuguese","Russian","Northern Sami","Udmurt","Chinese"]
    
    
    
    init(sourceModel: SourceModel, apiService:articleAPIServiceProtocol = ApiServices()) {
        self.apiService = apiService
        self.sourceModel = sourceModel
    }
    
    //MARK:- Setup values
    func setUpCountryList() {
        for i in 0..<countryCode.count {
            var countryModel = CountryModel()
            countryModel.countryCode = countryCode[i]
            countryModel.countryName = countryNameArray[i]
            self.countryListArray.append(countryModel)
        }
        self.selectedCountry = self.countryListArray[0]
    }
    
    func setUplanguageArray() {
        for i in 0..<languageCode.count {
            var languageModel = LanguageModel()
            languageModel.languageCode = languageCode[i]
            languageModel.languageName = languageNameList[i]
            self.languageArray.append(languageModel)
        }
        self.selectedLanguage = self.languageArray[0]
    }
    
    func setUpCategoryArray() {
        categoryArray =  ["All","Business", "Entertainment", "General", "Health", "Science","Technology"]
        self.selectedCategory = categoryArray[0]
    }
    
    //MARK:- Update Selected values
    func updateSelectedCategory(category: String) {
        self.selectedCategory = category
        makeSourceApiCall()
    }
    
    func updateSelectedCountry(country: String) {
        for item in countryListArray {
            if item.countryName == country {
                self.selectedCountry = item
            }
        }
        makeSourceApiCall()
    }
    
    func updateSelectedLanguage(language: String) {
        for item in languageArray {
            if item.languageName == language {
                self.selectedLanguage = item
            }
        }
        makeSourceApiCall()
    }
   
    //MARK:- Api call for article list
    func makeApiCall() {
        let finalURL = "https://newsapi.org/v2/top-headlines?sources=\(self.sourceValue ?? "")&apiKey=442339c823ba48be912e963c1271707b"
        
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
                        self.navigationClosure?()
                    } else {
                        self.showAlert?()
                    }
                }
            })
        }
    }
    
    //MARK:- Api call for source list
    func makeSourceApiCall() {
        let finalURL = "https://newsapi.org/v2/top-headlines/sources?language=\((self.selectedLanguage?.languageCode == "All" ? "" : self.selectedLanguage?.languageCode) ?? "")&category=\((self.selectedCategory == "All" ? "" : self.selectedCategory)  ?? "")&country=\((self.selectedCountry?.countryCode == "All" ? "" :self.selectedCountry?.countryCode) ?? "")&apiKey=442339c823ba48be912e963c1271707b"
        
        if Reachability.isConnectedToNetwork() {
            self.isLoading = true
            
            apiService.getSourceResponse(finalURL: finalURL, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    if status == true {
                        self.sourceModel = result as? SourceModel
                        self.isLoading = false
                        if self.sourceModel?.status == "error" {
                            self.showAlert?()
                            return
                        }
                        self.reloadClosure?()
                        
                    } else {
                        self.showAlert?()
                        
                    }
                }
            })
        }
    }
    
    
    func getSourceList(index: Int) ->String {
        return self.sourceModel?.sources?[index].name ?? ""
        
    }
    
    //Get num of rows
    func numberOfRows() ->Int {
        return (self.sourceModel?.sources?.count ?? 0) == 0 ? 1: (self.sourceModel?.sources?.count ?? 0)
    }
    
    func updateSourceValue(index: Int) {
        self.sourceValue = self.sourceModel?.sources?[index].id
    }
    
    //MARK:- view model values
    func viewModelForArtilceList() ->ArticlesListViewModel? {
        if let articlesModel = self.articlesModel {
            return ArticlesListViewModel.init(articlesModel: articlesModel,selectedCountry: "",selectedCategory: "", sourceValue: self.sourceValue ?? "" )
        }
        return ArticlesListViewModel(articlesModel: articlesModel!,selectedCountry: "",selectedCategory: "", sourceValue: self.sourceValue ?? "" )
    }
}
