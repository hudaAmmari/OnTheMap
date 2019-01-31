//
//  StudentInformation.swift
//  onTheMap
//
//  Created by Huda  on 24/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation
{
    
    let locationID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    
    init(_ dictionary: [String: AnyObject]) {
        self.locationID = dictionary["objectId"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
         }
    
    var fullName: String {
        return "\(firstName) \(lastName)" }

   
}

    struct SharedStudentsInformation {
        static var shared = SharedStudentsInformation()
        var studentsInformation = [StudentInformation]()
    }




