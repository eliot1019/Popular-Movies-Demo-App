//
//  File.swift
//  Make School Code Challenge
//
//  Created by Eliot Han on 3/18/17.
//  Copyright © 2017 Eliot Han. All rights reserved.
//

//Useful functions

import Foundation

struct UtilityFunctions {
    static var count = 0
    
    //Get data from a url, usually for images
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
        count += 1
    }
    
}