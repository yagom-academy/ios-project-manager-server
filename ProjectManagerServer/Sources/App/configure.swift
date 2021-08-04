import Vapor
import Fluent
import FluentPostgresDriver

// They configure file is used to configure the routes cofigured of the database comes figure the middleware.

// configures your application
public func configure(_ app: Application) throws {

    app.migrations.add(CreateProjectItem())

    app.databases.use(
        .postgres(hostname: "localhost", username: "sjsj", password: "", database: "toriDB"),
        as: .psql
    )

    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration =
            .makeClientConfiguration()
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        // ...
    }
    
    // register routes
    try routes(app)
}
