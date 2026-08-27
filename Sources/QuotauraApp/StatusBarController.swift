import AppKit
import Combine
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private let state: AppState
    private let statusItem: NSStatusItem
    private let popover = NSPopover()
    private var trackingArea: NSTrackingArea?
    private var cancellables = Set<AnyCancellable>()

    init(state: AppState) {
        self.state = state
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()

        configureStatusItem()
        configurePopover()
        observeState()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else { return }
        button.target = self
        button.action = #selector(togglePopover)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let area = NSTrackingArea(
            rect: button.bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        button.addTrackingArea(area)
        trackingArea = area
        updateStatusItem()
    }

    private func configurePopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = NSSize(width: 430, height: 640)
        popover.contentViewController = NSHostingController(rootView: StatusPanelView(state: state))
    }

    private func observeState() {
        state.$providers
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateStatusItem() }
            .store(in: &cancellables)
    }

    private func updateStatusItem() {
        guard let button = statusItem.button else { return }
        let remaining = state.globalRemainingPercent
        button.title = " AI \(remaining)%"
        button.image = NSImage(systemSymbolName: "gauge.with.dots.needle.33percent", accessibilityDescription: "Quotaura")
        button.imagePosition = .imageLeading
        button.contentTintColor = state.globalDemand == .peak ? .systemRed : .labelColor
        button.toolTip = "Quotaura · \(remaining)% disponible en la ventana más limitada"
    }

    override func mouseEntered(with event: NSEvent) {
        let preference = UserDefaults.standard.object(forKey: "openOnHover") as? Bool ?? true
        if preference { showPopover() }
    }

    @objc private func togglePopover() {
        popover.isShown ? popover.performClose(nil) : showPopover()
    }

    private func showPopover() {
        guard !popover.isShown, let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
}
