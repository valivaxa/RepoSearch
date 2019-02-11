//
//  RepoDetailsViewController.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import UIKit
import WebKit

class RepoDetailsViewController: UIViewController {
    var presenter: RepoDetailsViewOutput!
    
    private var webView = WKWebView()
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self, action: #selector(didPressDismiss))
    }
    
    @objc private func didPressDismiss() {
        presenter.didTriggerDismiss()
    }
}

extension RepoDetailsViewController: RepoDetailsView {
    func displayPage(with url: URL) {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
