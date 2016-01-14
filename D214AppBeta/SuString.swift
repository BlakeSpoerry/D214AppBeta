//
//  SuString.swift
//  Webviewplaying
//
//  Created by mobileapps on 10/16/15.
//  Copyright (c) 2015 JohnHerseyHighSchool. All rights reserved.
//

import UIKit

class SuString: NSObject {
    
    var myTitle: String
    var url: NSURL
    var info: String
    
    
    init(title: String, url: NSURL, info: String) {
        self.myTitle = title
        self.url = url
        self.info = info
        
    }
    
    func getName() -> String{
        return self.myTitle
    }
    func setName(newTitle: String){
        self.myTitle = newTitle
    }
    func getURL() -> NSURL{
        return self.url
    }
    func setURL(newURL: NSURL){
        self.url = newURL
    }
    func getInfo() -> String{
        return self.info
    }
    func setDescription(newInfo: String){
        self.info = newInfo
    }
    
    
    
}
