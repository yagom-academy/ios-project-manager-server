import Fluent

struct TaskMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("status")
            .case("toDo")
            .case("doing")
            .case("done")
            .create()
        return database.enum("status").read().flatMap { status in
            database.schema(Task.schema)
                .id()
                .field("title", .string, .required)
                .field("status", status, .required)
                .field("description", .string, .required)
                .field("date", .datetime, .required)
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
}
