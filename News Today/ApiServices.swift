//
//  ApiServices.swift
//  News Today
//
//  Created by Subendran on 25/07/21.
//  Copyright © 2021 Subendran. All rights reserved.
//

import Foundation

protocol  articleAPIServiceProtocol {
    func getArticleResponse(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getSourceResponse(finalURL: String,completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
}

class ApiServices: articleAPIServiceProtocol {
    func getSourceResponse(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "application/hal+json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    let values = try! decoder.decode(SourceModel.self, from: result!)
                    
                    
                    if values.status == "error" {
                        completion(false,errorCode,values as AnyObject?,error)
                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getArticleResponse(finalURL: String,completion: @escaping (Bool?,String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "application/hal+json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    let values = try! decoder.decode(ArticlesModel.self, from: result!)
                    
                    
                    if values.status == "error" {
                        completion(false,errorCode,values as AnyObject?,error)
                    }
                    completion(true,errorCode,values as AnyObject?,error)
                    
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
}

