import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    
    if let databaseURL = Environment.get("DATABASE_URL"),
       var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(configuration: postgresConfig
        ), as: .psql)
    } else {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? DatabaseInformation.username,
            password: Environment.get("DATABASE_PASSWORD") ?? DatabaseInformation.password,
            database: Environment.get("DATABASE_NAME") ?? DatabaseInformation.databaseName
        ), as: .psql)
    }
    
    app.migrations.add(CreateItem())
    try app.autoMigrate().wait()
    try routes(app)
}
