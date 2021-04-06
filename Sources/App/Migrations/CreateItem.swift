import Fluent

struct CreateItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        _ = database.enum("state")
            .case("todo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("state").read().flatMap { state in
            database.schema(Item.schema)
                .field("id", .custom("serial"))
                .field("title", .string, .required)
                .field("body", .string, .required)
                .field("state", state, .required)
                .field("deadline", .double)
                .field("last_modified", .datetime, .required)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Item.schema).delete()
    }
}
