import Fluent
import Vapor

struct AuthorController: RouteCollection {

   var authorpath: String = "authors";

   func boot(routes: RoutesBuilder) throws {
        let authors = routes.grouped("authors")
        authors.get(use: listAll)
        authors.post(use: create)
        authors.group(":authorID") { Author in
            Author.delete(use: delete)
            Author.post(use: edit)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let author = try req.content.decode(Author.self)
        return author.save(on: req.db).map { _ in
            return req.redirect(to: "/" + self.authorpath)
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response> {
        return Author.find(req.parameters.get("authorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { _ in
                return req.redirect(to: "/" + self.authorpath)
            }
    }

    func listAll(req: Request) throws -> EventLoopFuture<View> {
        let authorsList = Author.query(on: req.db).all()
        return authorsList.flatMap { authors in
          print(authors)
          let tmp = ["authorsList": authors]
          return req.view.render(self.authorpath, tmp)
        }
    }

    func edit(req: Request) throws -> EventLoopFuture<Response> {
        let up = try req.content.decode(Author.self)
        return Author.find(req.parameters.get("authorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { author in
                print(author)
                author.firstName = up.firstName
                author.lastName = up.lastName
                author.placeOfBirth = up.placeOfBirth
                print(author)
                return author.save(on: req.db).map { _ in
                    return req.redirect(to: "/" + self.authorpath)
                }
        }
    }
}