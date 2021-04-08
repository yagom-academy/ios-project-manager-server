import Fluent

struct CreateThing: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("state")
            .case("todo")
            .case("doing")
            .case("done")
            .create()
        return database.enum("state").read().flatMap { state in
            database.schema("things")
                .id()
                .field("title", .string)
                .field("description", .string)
                .field("state", state, .required)
                .field("due_date", .double, .required)
                .field("updated_at", .datetime, .required)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("things").delete()
    }
}
