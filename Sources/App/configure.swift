import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    configurePostgres(app)
    app.migrations.add(TaskMigration())
    configureDateStrategy()
    try routes(app)
}

private func configurePostgres(_ app: Application) {
    if let databaseURL = Environment.get("DATABASE_URL"),
       var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        guard let localPostgresData = try? String(contentsOfFile: LocalPostgres.filePath).data(using: .utf8),
              var localPostgres = try? JSONDecoder().decode(LocalPostgres.self, from: localPostgresData) else {
            return
        }
        if app.environment == .testing {
            localPostgres.database = "testdb"
        }
        app.databases.use(.postgres(hostname: LocalPostgres.hostname,
                                    username: localPostgres.username,
                                    password: localPostgres.password,
                                    database: localPostgres.database), as: .psql)
    }
}

private func configureDateStrategy() {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.outputFormatting = .sortedKeys
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    ContentConfiguration.global.use(encoder: encoder, for: .json)
    ContentConfiguration.global.use(decoder: decoder, for: .json)
}

private struct LocalPostgres: Decodable {
    static let filePath: String = DirectoryConfiguration.detect().workingDirectory + "Config/secrets/local_postgres.json"
    static let hostname: String = "localhost"

    let username: String
    let password: String
    var database: String
}
