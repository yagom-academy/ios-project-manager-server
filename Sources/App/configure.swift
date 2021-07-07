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
        throw Abort(.custom(code: 500, reasonPhrase: "configuration failed"))
    }

    app.migrations.add(MemoMigration())
    try routes(app)
}
