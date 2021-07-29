import Vapor
import PostgresKit
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        // ...
    }
    
    app.databases.use(.postgres(hostname: "localhost", username: "james", password: "", database: "taskdatabase"), as: .psql)
    
    app.migrations.add(TaskMigration())
    
    try routes(app)
}
