
//  bx wsk action create --kind nodejs:default actionjs1 Action1.js --web true
function main() { 
    return {
        statusCode: 201,
        headers: { 'Content-Type': 'application/json', 'header1': 'value1' },
        body: { "key1": "value1", "key2": "value2" }
    };
}