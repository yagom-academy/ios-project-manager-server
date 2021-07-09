//
//  TestAssets.swift
//  
//
//  Created by Ryan-Son on 2021/07/08.
//

@testable import App
import Foundation

enum TestAssets {
    static let projectItem = ProjectItem(title: "한 번만에 돼라", content: "123", deadlineDate: Date(), progress: .todo, index: 0)
    static let expectedTitle = "한 번만에 돼라"
    static let expectedContent = "123"
    static let expectedProgress = ProjectItem.Progress.todo
    static let expectedDeadlineDate = Date().formatted(as: "yyyy-MM-dd'T'HH:mm:ssZ")
    static let expectedIndex = 0
    static let expectedPatchTitle = "업데이트 됐어요!"
    static let expectedPatchContent = "성공적이야!"
    static let expectedPatchDeadlineDate = expectedDeadlineDate
    static let expectedPatchProgress = ProjectItem.Progress.doing
    static let expectedPatchIndex = 1
    static let todoProjectItemsURI = "/projectItems/todo"
    static let doingProjectItemsURI = "/projectItems/doing"
    static let projectItemURI = "/projectItem"
}
