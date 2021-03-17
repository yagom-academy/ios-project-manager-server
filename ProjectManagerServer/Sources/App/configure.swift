import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "zdo",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "mydb"
    ), as: .psql)
    
//    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
//        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
//        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
//    }

    app.migrations.add(CreateTodo())

    try routes(app)
}
