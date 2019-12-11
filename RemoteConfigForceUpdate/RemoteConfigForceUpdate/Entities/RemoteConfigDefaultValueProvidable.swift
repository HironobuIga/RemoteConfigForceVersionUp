//
//  RemoteConfigDefaultValueProvidable.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/11.
//  Copyright © 2019 Iganin. All rights reserved.
//

import Foundation

protocol RemoteConfigDefaultValueProvidable {
    static func defaultValue() -> NSObject?
}
