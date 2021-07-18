//
//  configure.swift
//
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.migrations.add(CreateProjectItem())
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        var clientTLSConfiguration = TLSConfiguration.makeClientConfiguration()
        clientTLSConfiguration.certificateVerification = .none
        postgresConfig.tlsConfiguration = clientTLSConfiguration
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        let databaseName: String
        let databasePort: Int
        
        if app.environment == .testing {
            databaseName = "project-manager-test"
            databasePort = 5433
        } else {
            databaseName = "project-manager-local"
            databasePort = 5432
        }
        
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? DBUserInfo.hostname,
            port: databasePort,
            username: Environment.get("DATABASE_USERNAME") ?? DBUserInfo.username,
            password: Environment.get("DATABASE_PASSWORD") ?? DBUserInfo.password,
            database: Environment.get("DATABASE_NAME") ?? databaseName
        ), as: .psql)
    }
    
    try app.autoMigrate().wait()
    
    try routes(app)
}
