import Fluent

struct CreateMemo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Memo.schema)
            .id()
            .field("title", .string)
            .field("description", .string)
            .field("date", .string)
            .field("status", .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Memo.schema).delete()
    }
}
