//
//  SettingsModel.swift
//  ReciteWords
//
//  Created by mac on 2022/1/5.
//

import Foundation

/**
 type:plain,title,detail,showMore,link,key
 type:input,title,isSecure,keyboardType,key
 type:switch,title,key
 type:stepper,title,minValue,maxValue,stepValue,key
 type:segment,title,options,key
 type:option,title,gid,multi,key
 */

//class SettingNode:Codable {
//    var title:String=""
//    var children:[SectionItem]?
//}

///type:1plain,2option,3segment,4switch，5stepper,6input

class SettingModel: Codable {
    var title: String
    var children:[SettingSection]
}

enum SettingSepc {
    case plain(String,Bool,String,[SettingSection])
    case option(String,Bool,Int)
    case segment(Int,[[Int:String]])
    case swatch(Int)
    case stepper(Int,Int,Int,Int)
    case input(String,Bool)
    
}

//extension SettingSepc:Codable {
//
//    enum CodingKeys: String, CodingKey {
//        case type
////        case key
////        case title
//
//        case detail
//        case showMore
//        case link
//        case children
//
//        case gid
//        case multi
//        case value
//
//        case options
//
//        case minValue
//        case maxValue
//        case stepValue
//
//        case isSecure
//    }
//
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let type = try container.decode(Int.self, forKey: .type)
//        switch type {
//        case 1:
//            let detail = try container.decode(String.self, forKey: .detail)
//            let showMore = try container.decode(Bool.self, forKey: .showMore)
//            let link = try container.decode(String.self, forKey: .link)
//            let children = try container.decode([SettingSection].self, forKey: .children)
//            self = .plain(detail, showMore, link, children)
//        default:
//            self = nil
//        }
//
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        //iterate over self and encode (1) the status and (2) the associated value(s)
//        switch self {
//        case .plain(let detail,let showMore,let link,let children):
//            try container.encode(1, forKey: .type)
//
//            try container.encode(detail, forKey: .detail)
//            try container.encode(showMore, forKey: .showMore)
//            try container.encode(link, forKey: .link)
//            try container.encode(children, forKey: .children)
//
//        case .option(let gid,let multi,let value):
//            try container.encode(gid, forKey: .gid)
//            try container.encode(multi, forKey: .multi)
//            try container.encode(value, forKey: .value)
//        case .segment(let value, let options):
//            try container.encode(options, forKey: .options)
//            try container.encode(value, forKey: .value)
//        case .swatch(let value):
//            try container.encode(value, forKey: .value)
//
//        case .stepper(let value,let minValue,let maxValue,let stepValue):
//            try container.encode(value, forKey: .value)
//            try container.encode(minValue, forKey: .minValue)
//            try container.encode(maxValue, forKey: .maxValue)
//            try container.encode(stepValue, forKey: .stepValue)
//
//        case .input(let value,let isSecure):
//            try container.encode(isSecure, forKey: .isSecure)
//            try container.encode(value, forKey: .value)
//
//        }
//    }
//}

class SettingItem:Codable {
    var type = 0
    var key:String!
    var title:String!

    //var content:SettingSepc
}

//class SettingPlain: SettingItem {
//    var detail:String?
//    var showMore = false
//    var link:String?
//    var children:[SettingSection]?
//}
//
//class SettingOption: SettingItem {
//    var gid:String!
//    var multi = true
//    var value = 1
//}
//
//class SettingSegment: SettingItem {
//    var options:[[Int:String]]!
//    var value = 0
//}
//
//class SettingSwitch: SettingItem {
//    var value = true
//}
//
//class SettingStepper: SettingItem {
//    var minValue = 0
//    var maxValue = 10
//    var stepValue = 1
//    var value = 1
//}
//
//class SettingInput: SettingItem {
//    var isSecure = false
//    var value = ""
//}
//
class SettingSection: Codable {
    var header:String?
    var children:[SettingItem]
    var footer:String?
}

///
///  detailType: 0无,1label,2checkmark,3segment,4switch，5stepper,6picker
///
//class SettingItem: SettingNode {
////    var detailType = 0
////    var detail:String?
////    var options:[String]?
////    var value = 0
//
//    var detail:SettingDetail?
//    var showDetail = false
//    var gid:Int
//    var link:String?
//
//    enum MyCodingKeys: String, CodingKey {
//        case detail
//        case showDetail
//        case gid
//        case link
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: MyCodingKeys.self)
//        self.detail = try container.decode(SettingDetail.self, forKey: .detail)
//        self.gid = try container.decode(Int.self, forKey: .gid)
//        self.showDetail = try container.decode(Bool.self, forKey: .showDetail)
//        self.link = try container.decode(String.self, forKey: .link)
//        try super.init(from: decoder)
//    }
//}


