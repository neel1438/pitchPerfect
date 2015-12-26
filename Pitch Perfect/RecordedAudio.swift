//
//  File.swift
//  Pitch Perfect
//
//  Created by Neel Bommisetty on 25/12/15.
//  Copyright © 2015 NeelBommisetty. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl :NSURL , title: String) {
        self.filePathUrl=filePathUrl
        self.title=title
    }
}