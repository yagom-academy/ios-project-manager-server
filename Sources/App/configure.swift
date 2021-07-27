import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let databaseURL = Environment.get("DATABASE_URL"),
       var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else { return }
<<<<<<< HEAD
    
//    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password: "", database: "testdb"), as: .psql)
=======
>>>>>>> ada45ede991d3ded2d5b8874bd8b0d1cb999f295
    
//    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password: "", database: "testdb"), as: .psql)

    app.migrations.add(CreateTask())

    // register routes
    try routes(app)
}
