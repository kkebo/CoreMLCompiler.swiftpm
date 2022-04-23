import QuickLook
import SwiftUI

struct QLView {
    let url: URL?
}

extension QLView: UIViewControllerRepresentable {
    typealias UIViewControllerType = QLPreviewController

    func makeUIViewController(
        context: Self.Context
    ) -> Self.UIViewControllerType {
        let vc = Self.UIViewControllerType()
        vc.dataSource = context.coordinator
        return vc
    }

    func makeCoordinator() -> Self.Coordinator {
        .init()
    }

    func updateUIViewController(
        _ uiViewController: Self.UIViewControllerType,
        context: Self.Context
    ) {
        context.coordinator.url = self.url
        uiViewController.reloadData()
    }
}

extension QLView {
    final class Coordinator: NSObject {
        var url: URL?
    }
}

extension QLView.Coordinator: QLPreviewControllerDataSource {
    func numberOfPreviewItems(
        in controller: QLPreviewController
    ) -> Int {
        self.url != nil ? 1 : 0
    }

    func previewController(
        _ controller: QLPreviewController,
        previewItemAt index: Int
    ) -> QLPreviewItem {
        PreviewItem(url: self.url)
    }
}

private final class PreviewItem: NSObject {
    let previewItemURL: URL?

    init(url: URL?) {
        self.previewItemURL = url
    }
}

extension PreviewItem: QLPreviewItem {}
