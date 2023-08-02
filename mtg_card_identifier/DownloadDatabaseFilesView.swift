//
//  DownloadDatabaseFilesView.swift
//  mtg_card_identifier
//
//  Created by Benjamin Patch on 8/1/23.
//

import SwiftUI
import ComposableArchitecture

struct DownloadDatabaseFilesViewReducer: Reducer {
    struct State: Equatable {
        let downloadButtonTitle = "Download Files"
        let downloadInformationText = "In order to make this app faster we download a database. This will take a couple minutes depending on your internet connection."
        let downloadingFilesText = "Download in progress!"
        var isDownloadingFile: Bool = false
        var downloadSuccessful: Bool?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case downloadButtonTapped
        case downloadFilesCompleted(Bool)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .downloadFilesCompleted(let success):
                // navigate to next page or something
                state.downloadSuccessful = success
                state.isDownloadingFile = false
                return .none
                
            case .downloadButtonTapped:
                state.isDownloadingFile = true
                return .run { send in
                    let result = await NetworkController.loadDatabaseFiles()
                    await send(.downloadFilesCompleted(result))
                }
                
            case .binding:
                return .none
            }
        }
    }
    
}

struct DownloadDatabaseFilesView: View {
    let store: StoreOf<DownloadDatabaseFilesViewReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isDownloadingFile {
                    Spacer()
                    Spacer()
                    Text(viewStore.downloadingFilesText)
                    Spacer()
                    ProgressView(value: 0.5)
                    Spacer()
                    
                } else {
                    Spacer()
                    Spacer()
                    Text(viewStore.downloadInformationText)
                    Spacer()
                    Button(viewStore.downloadButtonTitle) {
                        viewStore.send(.downloadButtonTapped)
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct DownloadDatabaseFilesView_Previews: PreviewProvider {
    static let store: StoreOf<DownloadDatabaseFilesViewReducer> = .init(initialState: .init(), reducer: {
        DownloadDatabaseFilesViewReducer()
    })

    static var previews: some View {
        DownloadDatabaseFilesView(store: store)
    }
}
