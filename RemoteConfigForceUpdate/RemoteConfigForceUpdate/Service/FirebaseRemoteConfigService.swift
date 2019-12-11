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
}

protocol RemoteConfigServiceProtocol {
    var expirationDuration: TimeInterval { get }
    
    func fetchAllData()
    func fetchData(forKey key: RemoteConfigParameterKey) -> String?
}

final class RemoteConfigService: RemoteConfigServiceProtocol {
    
    // Singletion
    static let shared = RemoteConfigService()
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        if AppUtility.isRelease == false {
            remoteConfig.configSettings.minimumFetchInterval = 0.0
        }
        
        remoteConfig.setDefaults(makeDefaultValues(forKeys: RemoteConfigParameterKey.allCases))
    }
    
    // MARK: - Prpoerty
    private let remoteConfig: RemoteConfig
    var expirationDuration: TimeInterval {
        switch AppUtility.buildType {
        case .debug: return 0.0
        case .release: return 60 * 60 // 1時間
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
    
    func fetchData(forKey key: RemoteConfigParameterKey) -> String? {
        return remoteConfig.configValue(forKey: key.rawValue).stringValue ??
            remoteConfig.defaultValue(forKey: key.rawValue)?.stringValue
    }
    
    private func makeDefaultValues(forKeys keys: [RemoteConfigParameterKey]) -> [String: NSObject] {
        var defaultValues = [String: NSObject]()
        keys.forEach { key in
            var defaultValue: NSString
            switch key {
            // パラメータ追加時はここにDefaultParameterを追加
            case .forceAlertInformation: defaultValue = "1.0.0"
            }
            defaultValues[key.rawValue] = defaultValue
        }
        
        return defaultValues
    }
}
