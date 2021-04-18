//
//  File.swift
//  
//
//  Created by 리나 on 2021/04/05.
//

import Vapor

struct ItemList: Content {
     let state: State
     let list: [Item]
 }
