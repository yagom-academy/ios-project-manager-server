import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    /// URL: /things
    /// GET: 전체 thing 반환
    /// POST: 새로운 thing 생성
    /// DELETE: 해당 thing 삭제
    /// PATCH: 해당 thing 수정
    
func routes(_ app: Application) throws {    
    try app.register(collection: ThingController(url: "things"))
}
