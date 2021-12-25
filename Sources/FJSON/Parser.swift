//
//  Parser.swift
//  
//
//  Created by Manaswi Daksha on 12/25/21.
//

import Astraea

struct Parser<T> {
    typealias RunParser = (String) -> (String, T)?
    let runParser: RunParser

    init(_ runParser: @escaping RunParser) {
        self.runParser = runParser
    }
}

// MARK: Building Blocks
let stringLiteral: Parser<String> = spanP { x in x != "\""}

let whiteSpace: Parser<String> = spanP { x in x.isWhitespace }

let colonParser: Parser<String> = { x in String(x) } <&> separator(":")

func separator(_ char: Character) -> Parser<String> {
    whiteSpace *> { x in String(x) } <&> charP(char) <* whiteSpace
}

// MARK: Building Functions
func charP(_ char: Character) -> Parser<Character> {
    .init { input in
        input.first == char ? (String.init <| input.dropFirst(), char) : nil
    }
}

func stringP(_ str: String) -> Parser<String> {
    { x in String(x) } <&> Parser<Any>.sequenceA <| str.map(charP)
}

func spanP(_ predicate: @escaping (Character) -> Bool) -> Parser<String> {
    .init { input in
        let (token, remainder) = { x in As.uncurry(x, As.span) } <| (input, predicate)
        return (remainder, token)
    }
}

func notNull(_ p: Parser<String>) -> Parser<String> {
    Parser<String>.init <| { val in val?.1 == "" || val == nil ? nil : val } <+ p.runParser
}

func sepBy<A,B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<[B]> {
    Parser<Any>.liftA2({ x in { y in [x] + y }}, b, Parser.many(a *> b)) <|> Parser.pure([])
}

// MARK: - Utilities
extension Parser: Functor {
    typealias A = T

    static func <&> <B>(f: @escaping (A) -> B, a: Parser<A>) -> Parser<B> {
        Parser<B>.init <| { val in { (x,y) in (x, f <| y) } <&> val } <+ a.runParser
    }

    static func <& <B>(a: A, b: Parser<B>) -> Parser<A> {
        { _ in a } <&> b
    }
}

extension Parser: Applicative {
    static func pure(_ a: A) -> Parser<A> {
        .init { input in (input, a) }
    }

    static func <*> <B>(a: Parser<(A) -> B>, b: Parser<A>) -> Parser<B> {
        Parser<B>.init <| { val in ({ (x,f) in (f <&> b).runParser(x) } <&> val) as? (String, B) } <+ a.runParser
    }

    static func liftA2 <A,B,C>(_ f: @escaping (A) -> ((B) -> C), _ a: Parser<A>, _ b: Parser<B>) -> Parser<C> { f <&> a <*> b }

    static func <* <B>(a: Parser<A>, b: Parser<B>) -> Parser<A> {
        liftA2({ input in { _ in input }}, a, b)
    }

    static func *> <B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<B> {
        As.id <& a <*> b
    }
}

extension Parser: Alternative {
    static var empty: Parser<A> { .init { _ in nil } }

    static func <|> (a: Parser<A>, b: Parser<A>) -> Parser<A> {
        .init { input in
            a.runParser(input) <|> b.runParser(input)
        }
    }

    static func many(_ a: Parser<A>) -> Parser<[A]> {
        .init { input in
            var input = input
            var array = [A]()

            while let (x, y) = a.runParser(input) {
                input = x
                array.append(y)
            }

            return (input, array)
        }
    }
}

extension Parser {
    static func sequenceA<A>(_ a: [Parser<A>]) -> Parser<[A]> {
        let a = a.reversed()
        let initial = Parser<[A]>.pure([])
        return a.reduce(initial) { acc, val in
            Parser<([A])->[A]>.init <| { val in  { (x,y) in (x, { arr in  [y] + arr }) } <&> val } <+ val.runParser <*> acc
        }
    }
}
