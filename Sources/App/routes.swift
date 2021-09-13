import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    //Libraries
    let libraryController = LibraryController()
    app.get("libraries", use: libraryController.listAll)
    app.post("libraries", use: libraryController.create)
    app.post("libraries", "edit", ":libraryID", use: libraryController.edit)
    app.post("libraries", "del", ":libraryID", use: libraryController.delete)

    //Authors
    let authorController = AuthorController()
    app.get("authors", use: authorController.listAll)
    app.post("authors", use: authorController.create)
    app.post("authors", "del", ":authorID", use: authorController.delete)
    app.post("authors", "edit", ":authorID", use: authorController.edit)

    //Books
    let bookController = BookController()
    app.get("books", use: bookController.listAll)
    app.post("books", use: bookController.create)
    app.post("books", "edit", ":bookID", use: bookController.edit)
    app.post("books", "del", ":bookID", use: bookController.delete)
}
