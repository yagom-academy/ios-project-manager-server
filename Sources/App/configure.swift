import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    configurePostgres(app)
    app.migrations.add(TaskMigration())
    try routes(app)
}

private func configurePostgres(_ app: Application) {
    if let databaseURL = Environment.get("DATABASE_URL"),
       var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }
}
