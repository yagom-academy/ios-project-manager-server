import Fluent
import SQLKit

struct CreateThing: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let stateDefaultValue = SQLColumnConstraintAlgorithm.default(State.todo.rawValue)
        return database.schema("things")
            .field("id", .custom("serial"))
            .field("title", .string, .required)
            .field("description", .string)
            .field("due_date", .datetime)
            .field("state", .string, .sql(stateDefaultValue))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("things").delete()
    }
}
