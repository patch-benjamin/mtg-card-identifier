//
//  ContentView.swift
//  mtg_card_identifier
//
//  Created by Benjamin Patch on 6/2/23.
//

import SwiftUI

class ContentViewViewModel: ObservableReducer {
    var state: State = State()
    
    func send(_ action: Action) {
        
    }
    
    enum Action {
        
    }
    struct State {
        var name = "Ben Patch"
        var age = "32"
        var detailViewState = DetailViewModel.State(thingsILikeToDo: ["Diy", "teaching", "tieing my shoes"])
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(viewModel.name)
                }
                HStack {
                    Text("Age:")
                    Spacer()
                    Text(viewModel.age)
                }
                NavigationLink("Things I like to do") {
                    DetailView(viewModel: DetailViewModel(state: viewModel.detailViewState))
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
