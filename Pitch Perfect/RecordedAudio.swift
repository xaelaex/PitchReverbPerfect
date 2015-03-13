//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Alex on 2/21/15.
//  Copyright (c) 2015 xaelaex. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrlI: NSURL, titleI: String) {
        filePathUrl = filePathUrlI
        title = titleI
               
    }

}