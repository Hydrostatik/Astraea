//
//  String+Extensions.swift
//  
//
//  Created by Manaswi Daksha on 12/29/21.
//

extension String: Semigroup {
    public static func <> (a: String, b: String) -> String {
        a + b
    }
}

extension String: Monoid {
    public static var mempty: String { "" }
}
