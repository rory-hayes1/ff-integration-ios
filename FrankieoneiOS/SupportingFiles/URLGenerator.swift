//
//  URLGenerator.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 27/06/23.
//

import Foundation

final class URLGenerator {
    static let getConfigFileName = "Environment"
    static let linksFileExtension = "plist"
    private static let webURLKey = "webURL"
    private static let createEntityURLKey = "createEntityURL"
    private static let frankiCustomerIDKey = "frankiCustomerID"
    private static let apiKey = "apiKey"
    private static let customerChildIDKey = "customerChildID"
    private static let userAgentKey = "userAgent"
    
    static var userAgent: String {
        return getValue(key: userAgentKey)
    }
    static var customerChildID: String {
        return getValue(key: customerChildIDKey)
    }
    static var apiKeyValue: String {
        return getValue(key: apiKey)
    }
    static var frankiCustomerID: String {
        return getValue(key: frankiCustomerIDKey)
    }
    static var createEntityURL: String {
        return getValue(key: createEntityURLKey)
    }
    static var webURL : String {
        return getValue(key: webURLKey)
    }
    
    static func getValue(key : String) -> String {
        let nsDictionary: NSDictionary?
        if let linksFilePath = Bundle.main.path(forResource: getConfigFileName, ofType: linksFileExtension) {
            nsDictionary = NSDictionary(contentsOfFile: linksFilePath)!
            let value = nsDictionary![key] as? String ?? ""
            return value
        }
        return ""
    }
}
