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
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        throw Abort(.internalServerError)
    }
    
    try routes(app)
}
