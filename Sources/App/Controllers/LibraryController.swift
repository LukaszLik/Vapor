import Fluent
import Vapor

struct LibraryController: RouteCollection {

   var libpath: String = "libraries";

   func boot(routes: RoutesBuilder) throws {
        let libraries = routes.grouped("libraries")
        libraries.get(use: listAll)
        libraries.post(use: create)
        libraries.group(":libraryID") { Library in
            Library.delete(use: delete)
            Library.post(use: edit)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let library = try req.content.decode(Library.self)
        return library.save(on: req.db).map { _ in
            return req.redirect(to: "/" + self.libpath)
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response> {
        return Library.find(req.parameters.get("libraryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { _ in
                return req.redirect(to: "/" + self.libpath)
            }
    }

    func listAll(req: Request) throws -> EventLoopFuture<View> {
        let librariesList = Library.query(on: req.db).all()
        return librariesList.flatMap { libraries in
          print(libraries)
          let tmp = ["librariesList": libraries]
          return req.view.render(self.libpath, tmp)
        }
      }

      func edit(req: Request) throws -> EventLoopFuture<Response> {
        let data = try req.content.decode(Library.self)
        return Library.find(req.parameters.get("libraryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { lib in
                lib.street = data.street
                lib.city = data.city
                lib.streetNumber = data.streetNumber
                lib.numberOfBooks = data.numberOfBooks
            return lib.save(on: req.db).map { _ in
                return req.redirect(to: "/" + self.libpath)
            }
        }
    }

}