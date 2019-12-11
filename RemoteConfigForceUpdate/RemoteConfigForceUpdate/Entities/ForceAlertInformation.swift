//
//  ForceAlertInformation.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/11.
//  Copyright © 2019 Iganin. All rights reserved.
//

import Foundation

struct ForceAlertInformation: Codable {
    let title: String
    let message: String
    let version: String
    let url: URL?
}

extension ForceAlertInformation {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        version = try container.decode(String.self, forKey: .version)
        let urlString = try? container.decode(String.self, forKey: .url)
        url = urlString == nil ? nil : URL(string: urlString!)
    }
}

extension ForceAlertInformation: RemoteConfigDefaultValueProvidable {
    static func defaultValue() -> NSObject? {
        let defaultValue = ForceAlertInformation(
            title: "確認",
            message: "新しいバージョンのアプリがあります。アップデートをお願いします。",
            version: "1.0.0",
            url: nil)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let defaultData = try? encoder.encode(defaultValue) else { return nil }
        return NSData(data: defaultData)
    }
}
