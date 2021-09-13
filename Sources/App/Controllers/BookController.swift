import Fluent
import Vapor

struct BookController: RouteCollection {

   var bookpath: String = "books";

   func boot(routes: RoutesBuilder) throws {
        let books = routes.grouped("books")
        books.get(use: listAll)
        books.post(use: create)
        books.group(":bookID") { Book in
            Book.delete(use: delete)
            Book.post(use: edit)
        }
    }

    struct Data: Content {
        let title: String
        let placeOfPublication: String
        let numPages: Int
        let authorId: UUID
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let data = try req.content.decode(Data.self)
        let book = Book(title: data.title, numPages: data.numPages, placeOfPublication: data.placeOfPublication, authorId: data.authorId)
        return book.save(on: req.db).map { _ in
            return req.redirect(to: "/" + self.bookpath)
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response> {
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { _ in
                return req.redirect(to: "/" +  self.bookpath)
            }
    }

    func listAll(req: Request) throws -> EventLoopFuture<View> {
        let booksList = Book.query(on: req.db).all()
        // let authorsList = Author.query(on: req.db).all()
        return booksList.flatMap { books in
          print(books)
          let tmp = ["booksList": books]
          return req.view.render(self.bookpath, tmp)
        }
    }

    func edit(req: Request) throws -> EventLoopFuture<Response> {
        let data = try req.content.decode(Data.self)
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.title = data.title
                book.placeOfPublication = data.placeOfPublication
                book.numPages = data.numPages
            return book.save(on: req.db).map { _ in
                return req.redirect(to: "/" + self.bookpath)
            }
        }
    }
}