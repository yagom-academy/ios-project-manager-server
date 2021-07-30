import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    if let databaseURL = Environment.get("DATABASE_URL") {
        app.databases.use(try .postgres(
            url: databaseURL
        ), as: .psql)
    } else {
        // ...
    }

    app.migrations.add(CreateTask())
    
    // register routes
    try routes(app)
}
