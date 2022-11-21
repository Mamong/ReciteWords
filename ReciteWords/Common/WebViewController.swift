//
//  WebViewController.swift
//  ReciteWords
//
//  Created by marco on 2022/1/14.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    private(set) var url: URL!
    
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWebView()
        loadURL(url)
    }
    
    func addWebView() {
        webView = WKWebView.init(frame: CGRect.zero)
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    public func loadURL(_ url:URL){
        self.url = url
        let request = URLRequest.init(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15)
        webView.load(request)
    }
    
    public func reload(){
        loadURL(url)
    }
}
