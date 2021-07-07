import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.databases.use(
        .postgres(hostname: "localhost",
                  username: "postgres",
                  password: "",
                  database: "memos"),
        as: .psql)
    
    app.migrations.add(MemoMigration())
    try app.register(collection: MemoController())
    try routes(app)
}
