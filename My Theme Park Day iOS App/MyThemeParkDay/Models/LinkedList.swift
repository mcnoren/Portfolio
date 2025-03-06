//
//  LinkedList.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/22/24.
//

import Foundation

public struct LinkedList {

    public var head: Node?
    public var tail: Node?
  
    init(photo_groups: [PhotoModel] = []) {
        for photo_group in photo_groups {
            self.append(value: photo_group)
        }
    }

    var isEmpty: Bool {
        head == nil
    }
    
    //Adds value to the front of the list
    mutating func push(value: PhotoModel) {
        head = Node(value: value, next: head)
        if head!.next != nil {
            head!.next!.previous = head
        }
        if tail == nil {
            tail = head
        }
    }
    
    //Adds value to the end of the list
    mutating func append(value: PhotoModel) {
        // 1
        guard !isEmpty else {
            push(value: value)
            return
        }
        // 2
        tail!.next = Node(value: value, previous: tail)
        // 3
        tail = tail!.next
    }
    
    func node(id: String) -> Node? {
      // 1
      var currentNode = head
      
      // 2
        while currentNode != nil && currentNode!.value.id != id {
        currentNode = currentNode!.next
      }
      
      return currentNode
    }
    
    // 1
    @discardableResult
    mutating func insert(_ value: PhotoModel,
                                after node: Node)
                                -> Node {
      // 2
      guard tail !== node else {
          append(value: value)
        return tail!
      }
      // 3
      node.next = Node(value: value, next: node.next)
      return node.next!
    }
    
    mutating func remove(day_id: String, schedule_id: String){
        var travel = head
        while travel != nil {
            if travel!.value.day_id == day_id && travel!.value.schedule_id == schedule_id {
                if travel!.previous != nil {
                    travel!.previous!.next = travel!.next
                }
                if travel!.next != nil {
                    travel!.next!.previous = travel!.previous
                }
                travel = nil
            }
        }
    }
    
    func get_value(day_id: String, schedule_id: String) -> PhotoModel? {
        var travel = head
        while travel != nil {
            if travel!.value.day_id == day_id && travel!.value.schedule_id == schedule_id {
                return travel!.value
            }
        }
        return nil
    }
}

extension LinkedList: CustomStringConvertible {

  public var description: String {
    guard let head = head else {
      return "Empty list"
    }
    return String(describing: head)
  }
}
