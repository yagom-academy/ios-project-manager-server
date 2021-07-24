import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    // ⭐️ 아래 내용을 추가하여 작성한 마이그레이션을 등록합니다.
    app.migrations.add(CreateProjectItem())

    app.databases.use(
        .postgres(hostname: "localhost", username: "kio", password: "", database: "sukio_database"),
        as: .psql
    )

    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        // ...
    }
    
    try routes(app)
}
