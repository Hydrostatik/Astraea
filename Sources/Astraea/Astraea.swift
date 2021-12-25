//
//  Astraea.swift
//  
//
//  Created by Manaswi Daksha on 12/24/21.
//

/// Namespace for most *non-operator* functions defined in the library
///
/// **Suggestion:** Use typealias to make the name shorter for convenience
@frozen public enum Astraea {
    /// Prefix synonym of the operator `<+`
    public static func compose<A,B,C>(_ f: @escaping (B) -> C,_ g: @escaping (A) -> B) -> ((A) -> C) { f <+ g }


    /// Applies the predicate to an array and returns a tuple where the first element is the longest prefix (possibly empty) of
    /// elements that satisfy the predicate. the second element is the remainder of the array.
    public static func span<Element>(_ array: Array<Element>, _ predicate: @escaping (Element) -> Bool) -> (Array<Element>, Array<Element>) {
        let newPredicate = { x in !x } <+ predicate
        if let firstIndex = array.firstIndex(where: newPredicate) {
            return (Array(array[..<firstIndex]), Array(array[firstIndex...]))
        }
        return (array, [])
    }

    /// Applies the predicate to a string and returns a tuple where the first element is the longest prefix (possibly "")
    /// that satisfies the predicate. the second element is the remainder of the string.
    public static func span(_ array: String, _ predicate: @escaping (Character) -> Bool) -> (String, String) {
        let newPredicate = { x in !x } <+ predicate
        if let firstIndex = array.firstIndex(where: newPredicate) {
            return (String(array[..<firstIndex]), String(array[firstIndex...]))
        }
        return (array, "")
    }
}
