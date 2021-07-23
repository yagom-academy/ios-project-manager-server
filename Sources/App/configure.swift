import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    let rawDatabaseURL = "postgres://ywommofyxcfnjo:501a6c902f36c547858fb305f1e47685909263fbc33334f4119795412ddecdef@ec2-52-71-231-37.compute-1.amazonaws.com:5432/dam3cth9soo9st"
    
    if let databaseURL = Environment.get(rawDatabaseURL),
       var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else { return }
    
    app.migrations.add(CreateTask())

    // register routes
    try routes(app)
}
