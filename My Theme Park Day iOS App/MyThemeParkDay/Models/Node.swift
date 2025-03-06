//
//  Node.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/22/24.
//

import Foundation

public class Node {

    var value: PhotoModel
    var previous: Node?
    var next: Node?
  
    init(value: PhotoModel, previous: Node? = nil, next: Node? = nil) {
        self.value = value
        self.previous = previous
        self.next = next
    }
}

extension Node: CustomStringConvertible {

    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}
