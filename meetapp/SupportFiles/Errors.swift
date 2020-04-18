//
//  Errors.swift
//  meetapp
//
//  Created by Maor Refaeli on 17/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case general(desc:String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .general(desc):
            return desc
        }
    }
}
