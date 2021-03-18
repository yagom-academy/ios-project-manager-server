import Vapor

struct ThingList: Content {
    var state: State
    var list: [ThingSimple]
}
