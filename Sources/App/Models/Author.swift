import Fluent
import Vapor

final class Author: Model, Content {
    static let schema = "authors"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "firstName")
    var firstName: String

    @Field(key: "lastName")
    var lastName: String

    @Field(key: "placeOfBirth")
    var placeOfBirth: String

    @Children(for: \.$authorId)
    var books: [Book]

    init() {
      // Intentionally unimplemented...
    }

    init (id:UUID? = nil, firstName:String, lastName:String, placeOfBirth:String){
      self.firstName = firstName
      self.lastName = lastName
      self.placeOfBirth = placeOfBirth
    }
}
