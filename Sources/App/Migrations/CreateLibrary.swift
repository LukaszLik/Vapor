import Fluent

struct CreateLibrary: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("libraries")
            .id()
            .field("street", .string, .required)
            .field("city", .string, .required)
            .field("streetNumber", .int, .required)
            .field("numberOfBooks", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("libraries").delete()
    }
}