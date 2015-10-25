//
//  SearchResult.swift
//  StoreSearch
//
//  Created by lgm on 15/10/25.
//  Copyright © 2015年 lgm. All rights reserved.
//

import UIKit

class SearchResult: NSObject{

    var name:String! = "";

    var artistName:String! = "";
    
    init(name:String, artistName:String) {
        self.name = name;
        self.artistName = artistName;
    }
    
}
