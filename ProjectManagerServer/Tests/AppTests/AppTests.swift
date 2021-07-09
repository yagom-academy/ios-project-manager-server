//
//  AppTests.swift
//
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    private var app: Application!
    
    override func setUpWithError() throws {
        print("시작")
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
        print("끝")
    }
    
    func testProjectItemCanBeRetrievedFromAPI() throws {
        try TestAssets.projectItem.save(on: app.db).wait()
        
        try app.test(.GET, TestAssets.todoProjectItemsURI, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            let todoProjectItems = try response.content.decode([ProjectItem].self)
            XCTAssertEqual(todoProjectItems.count, 1)
            XCTAssertEqual(todoProjectItems[0].title, TestAssets.expectedTitle)
            XCTAssertEqual(todoProjectItems[0].content, TestAssets.expectedContent)
            XCTAssertEqual(todoProjectItems[0].deadlineDate, TestAssets.expectedDeadlineDate)
            XCTAssertEqual(todoProjectItems[0].progress, TestAssets.expectedProgress)
            XCTAssertEqual(todoProjectItems[0].index, TestAssets.expectedIndex)
        })
    }
    
    func testProjectItemCanBeSavedWithAPI() throws {
        try app.test(.POST, TestAssets.projectItemURI, beforeRequest: { req in
            try req.content.encode(TestAssets.projectItem)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            let receivedProjectItem = try response.content.decode(ProjectItem.self)
            XCTAssertEqual(receivedProjectItem.title, TestAssets.expectedTitle)
            XCTAssertEqual(receivedProjectItem.content, TestAssets.expectedContent)
            XCTAssertEqual(receivedProjectItem.deadlineDate, TestAssets.expectedDeadlineDate)
            XCTAssertEqual(receivedProjectItem.progress, TestAssets.expectedProgress)
            XCTAssertEqual(receivedProjectItem.index, TestAssets.expectedIndex)
            
            try app.test(.GET, TestAssets.todoProjectItemsURI, afterResponse: { secondResponse in
                XCTAssertEqual(secondResponse.status, .ok)
                
                let todoProjectItems = try secondResponse.content.decode([ProjectItem].self)
                XCTAssertEqual(todoProjectItems.count, 1)
                XCTAssertEqual(todoProjectItems[0].title, TestAssets.expectedTitle)
                XCTAssertEqual(todoProjectItems[0].content, TestAssets.expectedContent)
                XCTAssertEqual(todoProjectItems[0].deadlineDate, TestAssets.expectedDeadlineDate)
                XCTAssertEqual(todoProjectItems[0].progress, TestAssets.expectedProgress)
                XCTAssertEqual(todoProjectItems[0].index, TestAssets.expectedIndex)
            })
        })
    }
    
    func testProjectItemCanBeUpdatedWithAPI() throws {
        let projectItem = TestAssets.projectItem
        let _ = try projectItem.save(on: app.db).wait()
        let patchProjectItem = PatchProjectItem(id: try projectItem.requireID(),
                                                title: "업데이트 됐어요!",
                                                content: "성공적이야!",
                                                deadlineDate: nil,
                                                progress: .doing,
                                                index: 1)
        
        try app.test(.PATCH, TestAssets.projectItemURI, beforeRequest: { req in
            try req.content.encode(patchProjectItem)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            let receivedProjectItem = try response.content.decode(ProjectItem.self)
            XCTAssertEqual(receivedProjectItem.title, TestAssets.expectedPatchTitle)
            XCTAssertEqual(receivedProjectItem.content, TestAssets.expectedPatchContent)
            XCTAssertEqual(receivedProjectItem.deadlineDate, TestAssets.expectedDeadlineDate)
            XCTAssertEqual(receivedProjectItem.progress, TestAssets.expectedPatchProgress)
            XCTAssertEqual(receivedProjectItem.index, TestAssets.expectedPatchIndex)
            
            try app.test(.GET, TestAssets.doingProjectItemsURI, afterResponse: { secondResponse in
                XCTAssertEqual(secondResponse.status, .ok)
                
                let doingProjectItems = try secondResponse.content.decode([ProjectItem].self)
                XCTAssertEqual(doingProjectItems.count, 1)
                XCTAssertEqual(doingProjectItems[0].title, TestAssets.expectedPatchTitle)
                XCTAssertEqual(doingProjectItems[0].content, TestAssets.expectedPatchContent)
                XCTAssertEqual(doingProjectItems[0].deadlineDate, TestAssets.expectedDeadlineDate)
                XCTAssertEqual(doingProjectItems[0].progress, TestAssets.expectedPatchProgress)
                XCTAssertEqual(doingProjectItems[0].index, TestAssets.expectedPatchIndex)
            })
        })
    }
    
    func testProjectItemCanBeDeletedWithAPI() throws {
        let projectItem = TestAssets.projectItem
        let _ = try projectItem.save(on: app.db).wait()
        let deleteProjectItem = DeleteProjectItem(id: try projectItem.requireID())
        
        try app.test(.DELETE, TestAssets.projectItemURI, beforeRequest: { req in
            try req.content.encode(deleteProjectItem)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            try app.test(.GET, TestAssets.todoProjectItemsURI, afterResponse: { secondResponse in
                XCTAssertEqual(secondResponse.status, .ok)
                
                let todoProjectItems = try secondResponse.content.decode([ProjectItem].self)
                XCTAssertEqual(todoProjectItems.count, 0)
            })
        })
    }
}
