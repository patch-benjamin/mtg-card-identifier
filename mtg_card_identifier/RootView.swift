//
//  RootView.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/11/23.
//

import SwiftUI
import ComposableArchitecture

struct RootViewReducer: Reducer {
    struct State: Equatable {
        var isDatabaseDownloaded = SQLiteFileManager.checkDatabaseStatus()
        var downloadDatabaseState = DownloadDatabaseFilesViewReducer.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case checkDatabaseDownloaded
        case downloadDatabaseFilesViewAction(DownloadDatabaseFilesViewReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .checkDatabaseDownloaded:
                state.isDatabaseDownloaded = SQLiteFileManager.checkDatabaseStatus()
                return .none
            case .binding(_):
                return .none
            case .downloadDatabaseFilesViewAction(_):
                return .none
            }
        }
    }
}
struct RootView: View {
    let store: StoreOf<RootViewReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            switch viewStore.isDatabaseDownloaded {
            case true:
                ContentView()
            case false:
                DownloadDatabaseFilesView(store: store.scope(state: \.downloadDatabaseState, action: RootViewReducer.Action.downloadDatabaseFilesViewAction))
            }
        }
    }
}
struct RootView_Previews: PreviewProvider {
    static let store: StoreOf<RootViewReducer> = .init(initialState: .init(), reducer: {
        RootViewReducer()
    })
    
    static var previews: some View {
        RootView(store: store)
    }
}
