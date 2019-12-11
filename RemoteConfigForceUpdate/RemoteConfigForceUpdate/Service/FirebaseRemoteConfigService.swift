//
//  FirebaseRemoteConfigService.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/11.
//  Copyright © 2019 Iganin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

// 取得するパラメータを定義します
enum RemoteConfigParameterKey: String, CaseIterable {
    case forceAlertInformation = "force_alert_information"
    
    var defaultValue: NSObject {
        switch self {
        case .forceAlertInformation: return "" as NSObject
        }
    }
}

// RemoteConfigの設定用Protocolです
protocol RemoteConfigServiceProtocol {
    func fetchAllData()
}

// RemoteConfigのプロパティ取得用Protocolです
protocol RemoteConfigPropertyProvider {
//    var forceAlertInformation: AnyObject { get }
}

final class RemoteConfigService: RemoteConfigServiceProtocol, RemoteConfigPropertyProvider {
    
    // Protocolを使用したDIが可能なようにインスタンスとして扱うようにしています
    // Singletion
    static let shared = RemoteConfigService()
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        // releaseビルドではない場合は取得感覚を0としています
        if !AppUtility.isRelease {
            remoteConfig.configSettings.minimumFetchInterval = 0.0
        }
        
        // 全てのデータを取得する前提で定義されているパラメータキーに対するデフォルト値を全て入れています
        remoteConfig.setDefaults(makeDefaultValues(forKeys: RemoteConfigParameterKey.allCases))
    }
    
    // MARK: - Prpoerty
    private let remoteConfig: RemoteConfig
    private var expirationDuration: TimeInterval {
        // debugビルドでは即時反映, releaseビルドでは一定時間あけるようにします
        switch AppUtility.buildType {
        case .debug: return 0.0
        case .release: return 10 * 60 // 10分間
        }
    }
    
    // MARK: - Function
    func fetchAllData() {
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (fetchStatus, error) in
            guard error == nil else { return }
            
            switch fetchStatus {
            case .success: self?.remoteConfig.activate(completionHandler: { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            case .failure, .noFetchYet, .throttled: break
            @unknown default: break
            }
        }
    }
    
    // RemoteConfigParameterKeyで定義したKeyに対してデフォルト値を決定し代入します
    private func makeDefaultValues(forKeys keys: [RemoteConfigParameterKey]) -> [String: NSObject] {
        var defaultValues = [String: NSObject]()
        keys.forEach { key in
            defaultValues[key.rawValue] = key.defaultValue
        }
        return defaultValues
    }
}
