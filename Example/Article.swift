//
//  Article.swift
//  Example
//
//  Created by Alejandro Ruperez Hernando on 23/8/17.
//

import Foundation

struct Article: Codable {

    public let title: String

    public init(title: String) {
        self.title = title
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let entry = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .entry)
        title = try entry.decode(String.self, forKey: .title)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var entry = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .entry)
        try entry.encode(title, forKey: .title)
    }

    enum CodingKeys: String, CodingKey {
        case entry = "entry"
    }

    enum AdditionalInfoKeys: String, CodingKey {
        case title = "title"
    }

}
