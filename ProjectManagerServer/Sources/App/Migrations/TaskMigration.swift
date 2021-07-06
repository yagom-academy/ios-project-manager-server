import Fluent

struct TaskMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("status")
            .case("toDo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("status").read().flatMap { status in
            database.schema("tasks")
                .id()
                .field("title", .string)
                .field("description", .string)
                .field("date", .int)
                .field("status", status)
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("tasks").delete()
    }
}

