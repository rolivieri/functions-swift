// Imports
import Foundation
import KituraContracts

// Simulate JSON payload (conforms to Employee struct below)
let json = """
{
 "name": "John Doe",
 "id": 123456
}
""".data(using: .utf8)! // our data in native (JSON) format

// Domain model/entity
struct Employee: Codable {
  let id: Int
  let name: String
}

// traditional main function
func main_traditional(args: [String:Any]) -> [String:Any] {
    print("args: \(args)")
    if let name = args["name"] as? String {
        return [ "greeting" : "Hello \(name)!" ]
    } else {
        return [ "greeting" : "Hello swif4!" ]
    }
}

// codable main function
func main_codable(input: Employee, respondWith: (Employee?, RequestError?) -> Void) -> Void {
    // For simplicity, just passing same Employee instance forward
    respondWith(input, nil)
}

// snippet of code "injected" (wrapper code for invoking traditional main)
func _run_main(mainFunction: ([String: Any]) -> [String: Any]) -> Void {
    print("------------------------------------------------")
    print("Using traditional style for invoking action...")
    let parsed = try! JSONSerialization.jsonObject(with: json, options: []) as! [String: Any]
    let result = mainFunction(parsed)
    print("Result (traditional main): \(result)")
    print("------------------------------------------------")
}

// snippet of code "injected" (wrapper code for invoking codable main)
func _run_main<In: Codable, Out: Codable>(mainFunction: CodableClosure<In, Out>) {
    print("------------------------------------------------")
    print("Using codable style for invoking action...")

    guard let input = try? JSONDecoder().decode(In.self, from: json) else {
        print("Something went really wrong...")
        return
    }

    let resultHandler: CodableResultClosure<Out> = { out, error in
        if let out = out {
            print("Received output: \(out)")
        }
    }
    
    let _ = mainFunction(input, resultHandler)

    print("------------------------------------------------")
}

// snippets of code "injected", dependending on the type of function the developer 
// wants to use traditional vs codable
_run_main(mainFunction:main_traditional)
_run_main(mainFunction:main_codable)

//Just testing error extension
//An extension does not allow overriding methods and properties,
//Which is getting in the way of computing the reason value for custom error codes
//May need to change the implementation we currently have in KituraContracts
let error = RequestError.customError1
let reason = error.reason
let desc = error.description
print("------------------------------------------------")
print(error)
print(reason)
print(desc)
print("------------------------------------------------")