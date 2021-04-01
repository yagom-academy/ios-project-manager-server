import Fluent

struct CreateItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("items")
            .id()
            .field("title", .string, .required)
            .field("body", .string, .required)
            .field("state", .string, .required)
            .field("deadline", .double)
            .field("last_modified", .double, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items").delete()
    }
}
