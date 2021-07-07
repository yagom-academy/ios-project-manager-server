import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        // ...
    }
    
//    app.databases.use(
//        .postgres(hostname: "localhost",
//                  username: "postgres",
//                  password: "",
//                  database: "memos"),
//        as: .psql)

    app.migrations.add(MemoMigration())
    try routes(app)
}
