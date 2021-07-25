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
    var selectedCountry: String?
    var selectedCategory: String?
    var articlesModel: ArticlesModel?
    var countryDetails = [CountryModel()]
    var sourceClicked: Bool = false
    
    var countryNameArray = ["Select Country","United Arab Emirates","Argentina","Austria","Australia","Belgium","Bulgaria","Brazil","Canada","Switzerland","China","Colombia","Cuba","Czechia","Germany","Egypt","France","United Kingdom of Great Britain and Northern Ireland","Greece","Hong Kong","Hungary","Indonesia","Ireland","Israel"," India","Italy","Japan","Korea","Lithuania","Latvia","Morocco","Mexico","Malaysia","Nigeria","Netherlands","Norway","New Zealand","Philippines","Poland","Portugal","Romania","Serbia","Russian","Saudi Arabia","Sweden","Singapore","Slovenia","Slovakia","Thailand","Turkey","Taiwan","Ukraine","United States of America","Venezuela","South Africa"]
    var countryCode = ["","ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za"]
    
    func setUpCountryDetails() {
        for i in 0..<countryCode.count {
            var countryModel = CountryModel()
            countryModel.countryCode = countryCode[i]
            countryModel.countryName = countryNameArray[i]
            self.countryDetails.append(countryModel)
        }
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
                    if self.articlesModel?.status == "error" {
                        completionHandler(false, nil, nil)
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
        if sourceClicked {
            return "https://newsapi.org/v2/top-headlines?sources&apiKey=32bf933974114bca8bef4f15db85a99c"
        } else {
            return "https://newsapi.org/v2/top-headlines?country=\(self.selectedCountry ?? "")&category=\( (self.selectedCategory == "Select Category" ? "": self.selectedCategory) ?? "")&apiKey=32bf933974114bca8bef4f15db85a99c"
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
            return ArticlesListViewModel.init(articlesModel: articlesModel,selectedCountry: self.selectedCountry ?? "",selectedCategory: self.selectedCategory ?? "" )
        }
        return ArticlesListViewModel(articlesModel: articlesModel!,selectedCountry: self.selectedCountry ?? "",selectedCategory: self.selectedCategory ?? "" )
    }
}
