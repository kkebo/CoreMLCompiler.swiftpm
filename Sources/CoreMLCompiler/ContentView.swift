import CoreML
import SwiftUI
import UniformTypeIdentifiers

struct ContentView {
    @State private var inputURL: URL?
    @State private var compiledURL: URL?
    @State private var isImporterPresented = false
}

extension ContentView: View {
    var body: some View {
        NavigationStack {
            QLView(url: self.inputURL)
                .fileImporter(
                    isPresented: self.$isImporterPresented,
                    allowedContentTypes: [
                        .init(filenameExtension: "mlmodel")!
                    ]
                ) { result in
                    switch result {
                    case .success(let url):
                        self.inputURL = url
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                    }
                }
                .onChange(of: self.inputURL) { url in
                    if let url {
                        self.compiledURL = try? MLModel.compileModel(at: url)
                    } else {
                        self.compiledURL = nil
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Open") {
                            self.isImporterPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let compiledURL {
                            ShareLink(item: compiledURL)
                                .labelStyle(.iconOnly)
                        }
                    }
                }
        }
    }
}
