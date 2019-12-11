//
//  AppUtility.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/11.
//  Copyright © 2019 Iganin. All rights reserved.
//

import Foundation

enum BuildType {
    case debug
    case release
}

struct AppUtility {
    static var buildType: BuildType {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
    
    static var isRelease: Bool {
        buildType == .release
    }
    
    static var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}

