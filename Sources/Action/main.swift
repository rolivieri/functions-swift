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

// codable main function (async)
func main_codable_async(input: Employee, respondWith: (Employee?, RequestError?) -> Void) -> Void {
    // For simplicity, just passing same Employee instance forward
    respondWith(input, nil)
}

// codable main function (async)
func main_codable_async_vanilla(input: Employee, respondWith: (Employee?, Error?) -> Void) -> Void {
    // For simplicity, just passing same Employee instance forward
    respondWith(input, nil)
}


// codable main function (sync)
func main_codable_sync(input: Employee) -> Employee {
    // For simplicity, just returning back the same Employee instance
    return input
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

// snippet of code "injected" (wrapper code for invoking codable main - async)
func _run_main<In: Codable, Out: Codable>(mainFunction: CodableClosure<In, Out>) {
    print("------------------------------------------------")
    print("Using codable style for invoking action (async style)...")

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

// snippet of code "injected" (wrapper code for invoking codable main - async - vanilla)
func _run_main<In: Codable, Out: Codable>(mainFunction: (In, (Out?, Error?) -> Void) -> Void) {
    print("------------------------------------------------")
    print("Using codable style for invoking action (async style - vanilla)...")

    guard let input = try? JSONDecoder().decode(In.self, from: json) else {
        print("Something went really wrong...")
        return
    }

    let resultHandler = { (out: Out?, error: Error?) in
        if let out = out {
            print("Received output: \(out)")
        }
    }
    
    let _ = mainFunction(input, resultHandler)

    print("------------------------------------------------")
}

// snippet of code "injected" (wrapper code for invoking codable main - sync - vanilla)
func _run_main<In: Codable, Out: Codable>(mainFunction: (In) -> Out) -> Void {
print("------------------------------------------------")
    print("Using codable style for invoking action (sync style - vanilla)...")

    guard let input = try? JSONDecoder().decode(In.self, from: json) else {
        print("Something went really wrong...")
        return
    }

    let result = mainFunction(input)
    print("Result (codable main sync): \(result)")
    print("------------------------------------------------")
}

// snippets of code "injected", dependending on the type of function the developer 
// wants to use traditional vs codable
_run_main(mainFunction:main_traditional)
_run_main(mainFunction:main_codable_async)
_run_main(mainFunction:main_codable_async_vanilla)
_run_main(mainFunction:main_codable_sync)

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