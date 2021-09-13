import Fluent

struct CreateBook: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("numPages", .int, .required)
            .field("placeOfPublication", .string, .required)
            .field("authorId", .uuid, .required)
            .foreignKey("authorId", references: Author.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("books").delete()
    }
}
