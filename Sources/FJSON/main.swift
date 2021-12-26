//
//  main.swift
//  
//
//  Created by Manaswi Daksha on 12/25/21.
//

import Astraea

typealias As = Astraea

enum JSONValue: Equatable {
    case null
    case bool(Bool)
    case number(Int)
    case string(String)
    case array(Array<JSONValue>)
    case object(Dictionary<String, JSONValue>)
}

typealias P = Parser

let jsonNull: Parser<JSONValue> = JSONValue.null <& stringP("null")

let jsonBool: Parser<JSONValue> = { x in
    switch x {
    case "true":
        return JSONValue.bool(true)
    case "false":
        return JSONValue.bool(false)
    default:
        fatalError("Parsing Unknown Bool Value...")
    }
} <&> (stringP("true") <|> stringP("false"))

let jsonNumber: Parser<JSONValue> = { x in JSONValue.number(Int(x)!) } <&> (notNull <| spanP { x in x.isNumber })

let jsonString: Parser<JSONValue> = { x in JSONValue.string(x) } <&> (charP("\"") *> stringLiteral <* charP("\""))

let jsonBase: Parser<JSONValue> = jsonNull <|> jsonBool <|> jsonNumber <|> jsonString

let jsonArray: Parser<JSONValue> = { x in
    JSONValue.array(x)
} <&> (charP("[") *> whiteSpace *> sepBy(separator(","), jsonBase) <* whiteSpace <* charP("]"))

let pairs: Parser<[String: JSONValue]> = .init { input in
    if let (rest , key) = (charP("\"") *> stringLiteral <* charP("\"")).runParser(input),
        let (rest1, pair) = (colonParser *> (jsonBase <|> jsonArray)).runParser(rest) {
            return (rest1, [key: pair])
    }

    return nil
}

let jsonObject: Parser<JSONValue> = { x in
    let merged = x.reduce([String: JSONValue](), { acc, val in
        var initialDict = acc
        initialDict.merge(val) { current, _ in
            current
        }
        return initialDict
    })
    return JSONValue.object(merged)
} <&> (charP("{") *> whiteSpace *> sepBy(separator(","), pairs) <* whiteSpace <* charP("}"))

print(
    jsonObject.runParser(
        "{ \"key\" : \"value\",\"OtherKey\": [2,3,4],\"integer\":123234234,\"boolean\" : true, \"missing\" : null }"
    )
)
