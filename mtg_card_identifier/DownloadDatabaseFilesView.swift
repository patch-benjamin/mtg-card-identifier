//
//  DownloadDatabaseFilesView.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 9/12/23.
//

import SwiftUI
import ComposableArchitecture


class URLSessionDownloader: NSObject, URLSessionDownloadDelegate {
    static var current: URLSessionDownloader?
    let sessionIdentifier: String
    var task: URLSessionDownloadTask?
    private(set) lazy var session: URLSession = {
        URLSession(configuration: .background(withIdentifier: sessionIdentifier), delegate: self, delegateQueue: OperationQueue())
    }()
    let progressRecieved: (Double) -> Void
    let didFinishDownloading: (URL?) -> Void
    
    private init(sessionIdentifier: String, url: URL, progressRecieved: @escaping (Double) -> Void, didFinishDownloading: @escaping (URL?) -> Void) {
        
        self.progressRecieved = progressRecieved
        self.sessionIdentifier = sessionIdentifier
        self.didFinishDownloading = didFinishDownloading
        super.init()
        self.task = session.downloadTask(with: url)
        task?.resume()
    }
    
    static func start(sessionIdentifier: String, url: URL, progressRecieved: @escaping (Double) -> Void, didFinishDownloading: @escaping (URL?) -> Void) -> Bool {
        guard self.current == nil else { return false }
        self.current = .init(sessionIdentifier: sessionIdentifier, url: url, progressRecieved: progressRecieved, didFinishDownloading: didFinishDownloading)

        let request = URLRequest(url: url)
        self.current?.task = URLSession.shared.downloadTask(with: request)
        self.current?.task?.resume()

        return true
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressRecieved(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        didFinishDownloading(location)
        Self.current = nil
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download failed with error: \(error.localizedDescription)")
            didFinishDownloading(nil)
        } else {
            print("Download completed successfully.")
        }
        Self.current = nil
    }
}

struct DownloadDatabaseFilesViewReducer: Reducer {
    struct State: Equatable {
        let downloadButtonTitle = "Download Files"
        let downloadInformationText = "In order to make this app faster we download a database. This will take a couple of minutes depending on your internet connection."
        var isDownloadingFile: Bool = false
        var downloadSuccessful: Bool?
        var navigateToContentView: Bool = false
        var downloadProgress: Double = 0.0
        var downloadMessage = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case downloadButtonTapped
        case downloadFilesCompleted(Bool)
        case continueButtonTapped
        case updateDownloadProgress(Double)
        case isDownloadingFile(Bool)
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
                    Task.init {
                         SQLiteFileManager.loadDatabaseFiles { progress in
                            DispatchQueue.main.async {
                                send(.updateDownloadProgress(progress))
                                print(progress)
                            }
                        } completion: { success in
                            DispatchQueue.main.async {
                                send(.isDownloadingFile(false))
                                send(.downloadFilesCompleted(success))
                            }
                        }
                    }
                }
            case .updateDownloadProgress(let progress):
                state.downloadProgress = progress

                if progress < 0.33 {
                    state.downloadMessage = "Download in progress 1/2"
                } else if progress < 0.66 {
                    state.downloadMessage = "Download in progress 2/2"
                } else {
                    state.downloadMessage = "Finishing download..."
                }

                return .none
            case .continueButtonTapped:
                state.navigateToContentView = true
                return .none

            case .binding:
                return .none
            case .isDownloadingFile(let isDownloading):
                state.isDownloadingFile = isDownloading
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
                    Text(viewStore.downloadMessage)
                    Spacer()
                    ProgressView(value: min(max(viewStore.downloadProgress, 0), 1))
                        .scaleEffect(x: 1, y: 2)
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
                    Button("Continue") {
                        viewStore.send(.continueButtonTapped)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .fullScreenCover(isPresented: viewStore.binding(
                        get: \.navigateToContentView,
                        send: DownloadDatabaseFilesViewReducer.Action.continueButtonTapped
                    ), content: {
                        ContentView()
                    })
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
                    Button("Delete Database") {
                     _ = SQLiteFileManager.deleteDatabaseFile()
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
