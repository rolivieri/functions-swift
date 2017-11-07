import Foundation

// Domain model/entity
struct Employee: Codable {
  let id: Int
  let name: String
}

func main_traditional(args: [String:Any]) -> [String:Any] {
    if let name = args["name"] as? String {
        return [ "greeting" : "Hello \(name)!" ]
    } else {
        return [ "greeting" : "Hello swif4!" ]
    }
}

func main_codable(input: Employee, respondWith: (Employee?, Error?) -> Void) -> Void {
    let user2 = Employee(id: 4545, name: "Peter")
    respondWith(user2, nil)
}

public typealias CodableResult<Out: Codable> = (Out?, Error?) -> Void
public typealias MainCodableFunction<In: Codable, Out: Codable> = (In, CodableResult<Out>) -> Void

func _run_main(mainFunction: ([String: Any]) -> [String: Any]) -> Void {
    print("Using traditional style for invoking action...")
    let parsed = ["key": "value"]
    let _ = mainFunction(parsed)
}

func _run_main<In: Codable, Out: Codable>(mainFunction: MainCodableFunction<In, Out>) {
     print("Using codable style for invoking action...")

let json = """
{
 "name": "John Doe",
 "id": 123456
}
""".data(using: .utf8)! // our data in native (JSON) format
    
    guard let input = try? JSONDecoder().decode(In.self, from: json) else {
        print("Something went really wrong...")
        return
    }

    let resultHandler: CodableResult<Out> = { out, error in
        if let out = out {
            print("Received output: \(out)")
        }
    }
    
    let _ = mainFunction(input, resultHandler)
}

_run_main(mainFunction:main_traditional)
_run_main(mainFunction:main_codable)
