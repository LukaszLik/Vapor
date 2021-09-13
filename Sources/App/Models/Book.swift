import Vapor
import Fluent

final class Book: Model, Content {
    static let schema = "books"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "numPages")
    var numPages: Int

    @Field(key: "placeOfPublication")
    var placeOfPublication: String

    @Parent(key: "authorId")
    var authorId: Author

    init() { 
        // Intentionally unimplemented...
    }

    init(id: UUID? = nil, title: String, numPages: Int, placeOfPublication: String, authorId: UUID) {
        self.id = id
        self.title = title
        self.numPages = numPages
        self.placeOfPublication = placeOfPublication
        self.$authorId.id = authorId
    }
}