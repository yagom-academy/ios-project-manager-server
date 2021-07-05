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
    app.migrations.add(CreateProjectItem(), to: .psql)
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        var clientTLSConfiguration = TLSConfiguration.makeClientConfiguration()
        clientTLSConfiguration.certificateVerification = .none
        postgresConfig.tlsConfiguration = clientTLSConfiguration
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        throw Abort(.internalServerError)
    }
    
    try routes(app)
}
