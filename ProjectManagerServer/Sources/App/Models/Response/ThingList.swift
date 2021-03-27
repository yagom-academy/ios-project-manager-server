import Vapor

struct ThingList: Content {
    let state: State
    let list: [ThingSimple]
}
