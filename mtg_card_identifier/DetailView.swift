//
//  DetailView.swift
//  mtg_card_identifier
//
//  Created by Benjamin Patch on 6/2/23.
//

import SwiftUI

class DetailViewModel: ObservableReducer {
    @Published var state: State
    
    init(state: State) {
        self.state = state
    }
    
    func send(_ action: Action) {
        switch action {
        case .addThingILikeToDo(let string):
            state.thingsILikeToDo.append(string)
            // reset the @State variable
        }
    }
    
    enum Action {
        case addThingILikeToDo(String)
    }
    
    struct State {
        var thingsILikeToDo: [String]
    }
}

/// List things we like to do
struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var newThing = ""
    
    var body: some View {
        VStack {
            List(viewModel.thingsILikeToDo, id: \.self) { thing in
                Text(thing)
            }
            TextField("New thing", text: $newThing)
                .padding()
            Button("Add new thing.") {
                viewModel.send(.addThingILikeToDo(newThing))
            }
             
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(state: DetailViewModel.State(thingsILikeToDo: [
            "DIY stuff",
            "coding projects with students",
            "eating Sushi",
            "listening to Brandon Sanderson"
        ])))
    }
}
