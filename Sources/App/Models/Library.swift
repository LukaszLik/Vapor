import Vapor
import Fluent

final class Library: Model, Content {
    static let schema = "libraries"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "street")
    var street: String

    @Field(key: "city")
    var city: String

    @Field(key: "streetNumber")
    var streetNumber: Int

    @Field(key: "numberOfBooks")
    var numberOfBooks: Int

    init() { 
        // Intentionally unimplemented...
    }

    init(id: UUID? = nil, street: String, city: String, streetNumber: Int, numberOfBooks: Int ) {
        self.id = id
        self.street = street
        self.city = city
        self.streetNumber = streetNumber
        self.numberOfBooks = numberOfBooks
    }
}