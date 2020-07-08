//
//  Filter.swift
//  ToolReleasesCore
//
//  Created by Maris Lagzdins on 19/05/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Foundation

public enum ToolFilter: CaseIterable, CustomStringConvertible {
    case all
    case beta
    case release

    public var description: String {
        switch self {
        case .all:
            return "All"
        case .beta:
            return "Beta"
        case .release:
            return "Released"
        }
    }
}

extension Array where Element == Tool {
    public func filtered(showBeta: Bool, showRelease: Bool) -> [Element] {
        if showBeta && showRelease {
            return self
        } else if showBeta {
            return self.filter { $0.isBeta || $0.isGMSeed }
        } else if showRelease {
            return self.filter { $0.isRelease }
        }
        return self.filter { $0.description == "random" }
    }
}
