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
    try routes(app)
    
    app.migrations.add(TaskMigration())
}
