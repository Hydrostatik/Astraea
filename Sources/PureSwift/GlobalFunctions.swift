//
//  GlobalFunctions.swift
//  
//
//  Created by Manaswi Daksha on 12/20/21.
//

infix operator <|
func <| <A,B>(f: (A) -> B, a: A) -> B { f(a) }

infix operator &&
func && <A,B,C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> ((A) -> C) {
    { a in
        g(f(a))
    }
}
