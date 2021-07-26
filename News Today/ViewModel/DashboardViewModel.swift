//
//  DashboardViewModel.swift
//  News Today

import Foundation
import Alamofire

struct CountryModel {
    var countryName: String?
    var countryCode: String?
}

class DashboardViewModel {
    var apiService: articleAPIServiceProtocol
    var selectedCountry: String?
    var selectedCategory: String?
    var articlesModel: ArticlesModel?
    var countryDetails = [CountryModel()]
    var sourceClicked: Bool = false
    var loadingClosure:(()->())?
    var showAlert:(() -> ())?
    var navigationClosure:(() ->())?
    
    var isLoading: Bool = false {
        didSet {
            self.loadingClosure?()
        }
    }
    
    init(apiService:articleAPIServiceProtocol = ApiServices()) {
        self.apiService = apiService
    }
    
    var countryNameArray = ["Select Country","United Arab Emirates","Argentina","Austria","Australia","Belgium","Bulgaria","Brazil","Canada","Switzerland","China","Colombia","Cuba","Czechia","Germany","Egypt","France","United Kingdom of Great Britain and Northern Ireland","Greece","Hong Kong","Hungary","Indonesia","Ireland","Israel"," India","Italy","Japan","Korea","Lithuania","Latvia","Morocco","Mexico","Malaysia","Nigeria","Netherlands","Norway","New Zealand","Philippines","Poland","Portugal","Romania","Serbia","Russian","Saudi Arabia","Sweden","Singapore","Slovenia","Slovakia","Thailand","Turkey","Taiwan","Ukraine","United States of America","Venezuela","South Africa"]
    var countryCode = ["","ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za"]
    
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
                        self.navigationClosure?()
                        
                    } else {
                        self.showAlert?()
                        
                    }
                }
            })
        }
    }
    
    func setUpCountryDetails() {
        for i in 0..<countryCode.count {
            var countryModel = CountryModel()
            countryModel.countryCode = countryCode[i]
            countryModel.countryName = countryNameArray[i]
            self.countryDetails.append(countryModel)
        }
    }
    
    
    func getFinalUrl() ->String {
        if sourceClicked {
            return "https://newsapi.org/v2/top-headlines/sources?apiKey=b5177be3e6ad4286b6dbc3d83421efd7"
        } else {
            return "https://newsapi.org/v2/top-headlines?country=\(self.selectedCountry ?? "")&category=\( (self.selectedCategory == "Select Category" ? "": self.selectedCategory) ?? "")&apiKey=b5177be3e6ad4286b6dbc3d83421efd7"
        }
    }
    
    func updateCountryName(countryName: String) {
        for item in countryDetails {
            if item.countryName == countryName {
                self.selectedCountry = item.countryCode
            }
        }
    }
    
    func updateCategory(category: String) {
        self.selectedCategory = category
    }
    
    func viewModelForArtilceList() ->ArticlesListViewModel? {
        if let articlesModel = self.articlesModel {
            return ArticlesListViewModel.init(articlesModel: articlesModel,selectedCountry: self.selectedCountry ?? "",selectedCategory: self.selectedCategory ?? "", sourceValue: "" )
        }
        return ArticlesListViewModel(articlesModel: articlesModel!,selectedCountry: self.selectedCountry ?? "",selectedCategory: self.selectedCategory ?? "", sourceValue: "" )
    }
    
    func viewModelForSourceViewController() ->SourceViewModel? {
        if let articleModel = self.articlesModel {
            return SourceViewModel.init(articlesModel: articleModel)
        }
        return SourceViewModel.init(articlesModel: self.articlesModel!)
    }
}
