//
//  VocabularyResModel.swift
//  ReciteWords
//
//  Created by mac on 2021/9/25.
//

import Foundation

struct VocabularyResModel: Codable {
    var error: Int
    var msg: String
    var data: VocabularyData
}

struct VocabularyData: Codable {
    var books: [BookModel]
    var mappingKey: MappingKeyData
    
    enum CodingKeys: String, CodingKey {
        case books
        case mappingKey = "mapping_key"
    }
}

struct BookModel: Codable {
    var wordCount: Int
    var name: String
    var nameEn: String
    var id: Int
    var thesaurusId: Int
    var version: Int
    var url: String
    var desc: String
    var descEn: String
    var majorType: Int
    var importanceType: Int
    var tag: String
    var tagEn: String?
    var reason: String
    var reciteCnt: String
    var dailyWordCount: Int
    var recitationsNum: Int
    var sortMap: [SortMapModel]
    var status: Int

    
    enum CodingKeys: String, CodingKey {
        case wordCount = "word_count"
        case name
        case nameEn = "name_en"
        case id
        case thesaurusId
        case version
        case url
        case desc
        case descEn = "desc_en"
        case majorType = "major_type"
        case importanceType = "importance_type"
        case tag
        case tagEn = "tag_en"
        case reason
        case reciteCnt = "recite_cnt"
        case dailyWordCount = "daily_word_count"
        case recitationsNum = "recitations_num"
        case sortMap
        case status
    }
}

struct SortMapModel: Codable {
    var type: Int
    var text: String
    var textEn: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case textEn = "text_en"
    }
}

struct MappingKeyData: Codable {
    var version: Int
    var importanceData: [MappingKeyModel]
    var majorData: [MappingKeyModel]

    enum CodingKeys: String, CodingKey {
        case version
        case importanceData = "importance_data"
        case majorData = "major_data"
    }
}


struct MappingKeyModel: Codable {
    var name: String
    var nameEn: String
    var key: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case nameEn = "name_en"
        case key
    }
}

