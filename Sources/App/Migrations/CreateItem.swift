import Fluent

struct CreateItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("items").delete()
    }
}
