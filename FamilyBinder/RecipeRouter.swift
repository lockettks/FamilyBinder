//
//  RecipeRouter.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import Alamofire
enum RecipeRouter: URLRequestConvertible {
    static let baseURLString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/"
    
    case getPublic()
    case getRandomRecipes(Int)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPublic, .getRandomRecipes:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .getPublic, .getRandomRecipes:
                relativePath = "recipes/random/"
                
            }
            var url = URL(string: RecipeRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let params: ([String: Any]?) = {
            switch self {
            case .getPublic:
                return nil
            case .getRandomRecipes(let numberOfRecipes):
                return ["number": numberOfRecipes]
            }
        }()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("YEIh3dEwxWmshaSX7VYL5JASH8Lfp1HSA4ijsnaE4f4LT3zTTy", forHTTPHeaderField: "X-Mashape-Key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
