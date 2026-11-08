import SwiftUI

/// Selects the layout density used by Braisenly components.
public enum BraisenlyPlatform: Sendable, Equatable {
    case automatic
    case iPhone
    case iPad
    case mac

    public func resolved(horizontalSizeClass: UserInterfaceSizeClass?) -> Self {
        guard self == .automatic else { return self }
#if os(macOS)
        return .mac
#else
        return horizontalSizeClass == .regular ? .iPad : .iPhone
#endif
    }

    public var controlSize: CGFloat {
        switch self {
        case .iPhone, .automatic: 44
        case .iPad: 48
        case .mac: 36
        }
    }

    public var rowHeight: CGFloat {
        switch self {
        case .iPhone, .automatic: 48
        case .iPad: 52
        case .mac: 40
        }
    }

    public var contentMaxWidth: CGFloat {
        switch self {
        case .iPhone, .automatic: .infinity
        case .iPad: 760
        case .mac: 860
        }
    }
}
