//
//  PXRefreshBundle.swift
//  ReciteWords
//
//  Created by marco on 2022/3/2.
//

import Foundation

class PXRefreshBundle:PXBundle {
    
    override var bundleName: String{
        return "PXRefresh"
    }

    /** Singleton Config instance */
    public static let shared = PXRefreshBundle()

    private override init() {
        super.init()
    }
}
