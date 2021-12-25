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

    /// The identity function.
    public static func id<A>(_ a: A) -> A { a }

    /// A unary function which evaluates to a for all inputs.
    public static func const<A,B>(_ a: A,_ b: B) -> A { a }

    /// Converts a function that takes a 2D tuple, to one that takes two arguments.
    public static func curry<A,B,C>(_ a: A, _ b: B, _ f: @escaping (((A, B)) -> C)) -> C {
        f <| (a,b)
    }

    /// Converts a function that takes two arguments to a function that takes a 2D tuple.
    public static func uncurry<A,B,C>(_ val: (A, B), _ f: @escaping ((A, B) -> C)) -> C {
        f(val.0, val.1)
    }

    /// Converts a function that takes two arguments to a function that takes a 3D tuple.
    public static func uncurry3<A,B,C,D>(_ val: (A,B,C), _ f: @escaping((A,B,C) -> D)) -> D {
        f(val.0, val.1, val.2)
    }

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
