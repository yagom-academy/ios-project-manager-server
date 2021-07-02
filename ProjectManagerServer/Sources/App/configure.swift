import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.migrations.add(CreateProjectItem())
    
    let databaseURL = "postgres://krlhuxlszenkwz:984a411cee1a56ca3f467c9a247749569b7be24476e9cd68ba9f1d9a35e59003@ec2-34-202-54-225.compute-1.amazonaws.com:5432/d4s708j7913lfc"
    
    if let databaseURL = Environment.get(databaseURL) {
        app.databases.use(try .postgres(
            url: databaseURL
        ), as: .psql)
    } else {
        throw Abort(.internalServerError)
    }
    
    try routes(app)
}
