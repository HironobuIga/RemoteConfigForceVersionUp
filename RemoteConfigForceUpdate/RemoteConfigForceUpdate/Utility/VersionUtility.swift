//
//  VersionUtility.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/12.
//  Copyright © 2019 Iganin. All rights reserved.
//

import Foundation

struct VersionUtility {
    // 現在のバージョンと比較対象のバージョンを比べ強制アラートの表示が必要かを判定します
    func isForceAlertRequired(currentVersion: String, criteriaVersion: String) -> Bool {
        
        var currentVersionNumbers = currentVersion.components(separatedBy: ".").map { Int($0) ?? 0 }
        var criteriaVersionNumbers = currentVersion.components(separatedBy: ".").map { Int($0) ?? 0 }
        let countDifference = currentVersionNumbers.count - criteriaVersionNumbers.count
        
        switch countDifference {
        case 0..<Int.max: criteriaVersionNumbers.append(contentsOf: Array(repeating: 0, count:abs(countDifference)))
        case Int.min..<0: currentVersionNumbers.append(contentsOf: Array(repeating: 0, count:abs(countDifference)))
        default: break // 個数同じ
        }
        
        // major versionから順に比較していき、同値でなくなった時に大小比較結果を返す
        for (current, criteria) in zip(currentVersionNumbers, criteriaVersionNumbers) {
            if current > criteria {
                return false
            } else if current < criteria {
                return true
            }
        }
        // 同値
        return false
    }
}
