import Fluent

struct HistoryMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("action")
            .case("Moved")
            .case("Added")
            .case("Removed")
            .create()
        return database.enum("action").read().flatMap { action in
            database.schema(Task.schema)
                .id()
                .field("action", action, .required)
                .field("previousStatus", .string)
                .field("changedStatus", .string)
                .field("updatedTitle", .string)
                .field("task", .dictionary, .required)
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(History.schema).delete()
    }
}
