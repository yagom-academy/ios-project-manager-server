//
//  File.swift
//  
//
//  Created by 김지혜 on 2021/03/13.
//

import Vapor

struct ThingList: Content {
    var state: State
    var list: [ThingSimple]
}
