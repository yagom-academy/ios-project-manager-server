import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.migrations.add(CreateProjectItem())
    
    app.databases.use(.postgres(hostname: "localhost", username: "leeyoungwoo", password: "", database: "project-management-appserver"), as: .psql)

    // register routes
    try routes(app)
}
