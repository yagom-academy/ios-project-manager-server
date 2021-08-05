import Vapor
import Fluent
import FluentPostgresDriver

// They configure file is used to configure the routes cofigured of the database comes figure the middleware.

// configures your application
public func configure(_ app: Application) throws {
    
    app.migrations.add(CreateProjectItem())
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        var clientTLSConfiguration = TLSConfiguration.makeClientConfiguration()
        clientTLSConfiguration.certificateVerification = .none
        postgresConfig.tlsConfiguration = clientTLSConfiguration
        app.databases.use(
            .postgres(configuration: postgresConfig),
            as: .psql
        )
    } else {
        app.databases.use(
            .postgres(hostname: "localhost", username: "kio", password: "", database: "skdb"),
            as: .psql
        )
    }
    
    // register routes
    try routes(app)
}
