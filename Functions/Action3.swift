import Foundation

// bx wsk action create --kind swift:3.1.1 action3 Action3.swift --web true
// By default, when you create a web action, you can use all of the verbs listed here to access the action: 
// https://github.com/apache/incubator-openwhisk/blob/master/docs/webactions.md#additional-features
// The actual HTTP response from a web action depends on the content extension specified in the URL:
// https://openwhisk.ng.bluemix.net/api/v1/web/roliv%40us.ibm.com_dev/default/action3.json
// https://openwhisk.ng.bluemix.net/api/v1/web/roliv%40us.ibm.com_dev/default/action3.http
func main(args: [String:Any]) -> [String:Any] {

    var result: [String:Any] = [
        "headers": [ "header1": "value1" ],
        "statusCode": 201,
        "body": args     
    ]
    
    return result
}
