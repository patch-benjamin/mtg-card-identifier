//
//  DownloadDatabaseFilesView.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/4/23.
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
        var navigateToContentView: Bool = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case downloadButtonTapped
        case downloadFilesCompleted(Bool)
        case continueButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .downloadFilesCompleted(let success):
                state.downloadSuccessful = success
                state.isDownloadingFile = false
                return .none

            case .downloadButtonTapped:
                state.isDownloadingFile = true
                return .run { send in
                    let result = await NetworkController.loadDatabaseFiles()
                    await send(.downloadFilesCompleted(result))
                }
            case .continueButtonTapped:
                state.navigateToContentView = true
                return .none

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

                } else if let downloadSuccessful = viewStore.downloadSuccessful {
                    Spacer()
                    Spacer()
                    Text(downloadSuccessful ? "Download Successful!" : "Download Failed!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(downloadSuccessful ? .green : .red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    Spacer()
                    Button("Continue", action: {
                        if viewStore.navigateToContentView {
                            //navigate to ContentView
                        }
                    })
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
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
