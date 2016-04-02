//
//  Entry.swift
//  XMLParsing
//
//  Created by Naga Praveen Kumar Pendyala on 2/8/16.
//  Copyright (c) 2016 Naga Praveen Kumar Pendyala. All rights reserved.
//

import Foundation

class Entry {
    
    var title: String
    var summary: String
    var image: String
    
    init(title: String, summary: String, image: String)
    {
        self.title = title
        self.summary = summary
        self.image = image
        
    }
    
}