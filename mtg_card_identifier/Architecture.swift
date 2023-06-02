//
//  Architecture.swift
//  MVI_Test
//
//  Created by Benjamin Patch on 6/1/23.
//

import Foundation
import SwiftUI

/// `PropertyWrapper` overview: https://nshipster.com/propertywrapper
/// The purpose of this propertywrapper is to allow us to get a `Binding` to variables on `State`,
/// while continuing the uni-directional data-flow we get with `ObservableResducer.send(_ action: Action)`
/// In other words, you should never mutate state outside of the `send(_ action: Action)` function, and this propertyWrapper makes that possible with `Bindings`
@propertyWrapper
struct Settable<Action, Value> {
    var wrappedValue: Value
    var action: (Value) -> Action
    
    /// ProjectedValue is what is returned when you reference a wrapped variable (`@Settable` `$someWrappedVariable`
    public var projectedValue: Self {
      get { self }
      set { self = newValue }
    }
    
    init(wrappedValue value: Value, _ action: @escaping (Value) -> Action) {
        self.wrappedValue = value
        self.action = action
    }
}

// dynamicMemberLookup: see the comments on the `subscript` function below.
@dynamicMemberLookup
protocol ObservableReducer: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    func send(_ action: Action)
}

extension ObservableReducer {
    
    /// This is the required function for the above `@dynamicMemberLookup`. You can learn more about the magic of this function here: https://www.swiftbysundell.com/tips/combining-dynamic-member-lookup-with-key-paths/
    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }

    /// This lets you get a Binding to a state value that is wrapped by `@Settable`.
    ///
    ///        class MyReducer: ObservableReducer {
    ///            struct State {
    ///                @Settable(Action.updateName) var name: String = ""
    ///            }
    ///            private(set) var state = State()
    ///        }
    ///        struct MyView: View {
    ///            @ObservedObject var reducer = MyReducer()
    ///            var body: some View {
    ///                TextField("name", text: reducer.$name)

    /// In the above example, `reducer.$name` is being re-routed to this subscript,
    /// which takes a `Settable<Value>` object (the `.$name`, which will grab the `projectedValue` of the `Settable` object, which is a `Settable<Value>`)
    /// and returns a `Binding<Value>`, which is what `TextField` requires.
    subscript<Value>(dynamicMember keyPath: KeyPath<State, Settable<Action, Value>>) -> Binding<Value> {
        .init {
            self.state[keyPath: keyPath].wrappedValue
        } set: { newValue in
            let settable = self.state[keyPath: keyPath]
            self.send(settable.action(newValue))
        }
    }
}

