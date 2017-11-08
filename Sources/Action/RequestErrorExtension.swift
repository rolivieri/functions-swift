import Foundation
import KituraContracts

/// An extension to Kitura RequestErrors with additional error codes specifically for the client.
extension RequestError {

    /// An initializer to set up the client error codes.
    /// - Parameter clientErrorCode: The custom error code for the client.
    init(clientErrorCode: Int) {
        self.init(rawValue: clientErrorCode)
    }
    
    public static var customError1 = RequestError(clientErrorCode: 900)
    public static var customError2 = RequestError(clientErrorCode: 901)
    //...

}