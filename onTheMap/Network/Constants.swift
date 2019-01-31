//
//  Constants.swift
//  onTheMap
//
//  Created by Huda  on 28/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: - Commons
    
    struct HTTPHeaderField {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct HTTPHeaderFieldValue {
        static let json = "application/json"
    }
    
    // MARK: - Udacity API
    
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIPath = "/v1"
    }
    
    struct UdacityMethods {
        static let Authentication = "/session"
        static let Users = "/users"
    }
    
    struct UdacityJSONResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let UserKey = "key"
        static let Session = "session"
        static let SessionID = "id"
    }
    
    // MARK: - Parse API
    
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse"
    }
    
    struct ParseMethods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    struct ParseJSONResponseKeys {
        static let Results = "results"
    }
    
    struct ParseParameterKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let Where = "where"
        static let LimitAndOrder = "?limit=100&order=-updatedAt"
        static let order = "order"
        static let limit = "limit"
    }
    
    struct ParseParametersValues {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}
