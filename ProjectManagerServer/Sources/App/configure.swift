import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
        app.databases.use(.postgres(hostname: "localhost", username: "babywalnut", password: "", database: "project_manager_database"), as: .psql)
        app.migrations.add(CreateTask())
    
    // register routes
    try routes(app)
}
