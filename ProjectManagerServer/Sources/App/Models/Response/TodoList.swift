//
//  TodoList.swift
//  
//
//  Created by Yeon on 2021/03/25.
//

import Vapor

struct TodoList: Content {
    let todoList: [OneTodo]
}
