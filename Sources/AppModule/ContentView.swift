import CoreML
import SwiftUI
import UniformTypeIdentifiers

struct ContentView {
    @State var inputURL: URL?
    @State var compiledURL: URL?
    @State var isImporterPresented = false
    @State var isExporterPresented = false
    @State var isProcessing = false
}

extension ContentView: View {
    var body: some View {
        NavigationView {
            QLView(url: inputURL)
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
                .fileMover(
                    isPresented: self.$isExporterPresented,
                    file: self.compiledURL
                ) { _ in }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Open") {
                            self.isImporterPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Compile & Save") {
                            guard let url = self.inputURL else { return }
                            self.compiledURL = try? MLModel.compileModel(at: url)
                            self.isExporterPresented = true
                        }
                        .disabled(self.inputURL == nil)
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
