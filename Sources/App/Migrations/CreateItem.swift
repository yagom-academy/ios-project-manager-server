import Fluent

struct CreateItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        _ = database.enum("state")
            .case("todo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("state").read().flatMap { state in
            database.schema("items")
                .id()
                .field("title", .string, .required)
                .field("body", .string, .required)
                .field("state", state, .required)
                .field("deadline", .double)
                .field("last_modified", .double, .required)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items").delete()
    }
}
