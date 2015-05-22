//
//  SCDomElementView.swift
//  SCDomElementView
//
//  Created by Jeff Boek on 5/21/15.
//  Copyright (c) 2015 spiltcocoa. All rights reserved.
//

import UIKit
import WebKit

public class SCDomElementView: UIView, WKNavigationDelegate {

	public let scrollView = UIScrollView()

	private(set) lazy var webView: WKWebView = {
		let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'initial-scale=1.0'); document.getElementsByTagName('head')[0].appendChild(meta);"
		let script = WKUserScript(source: js, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)

		let controller = WKUserContentController()
		controller.addUserScript(script)

		let config = WKWebViewConfiguration()
		config.userContentController = controller

		return WKWebView(frame: self.frame, configuration: config)
		}()

	public override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		configure()
	}

	private func configure() {
		backgroundColor = UIColor.redColor()
		webView.navigationDelegate = self
//		webView.userInteractionEnabled = false

		addSubview(webView)
//		scrollView.addSubview(webView)
	}

	private func rectFromId(id: String, callback: (CGRect) -> ()) {
		var javascript = "function f(){ var r = document.getElementById('\(id)').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";

		webView.evaluateJavaScript(javascript) { result, error in
			if error != nil { return }

			if let result = result as? String {
				let rect = CGRectFromString(result)

				callback(rect)
			}
		}
	}

	public func loadRequest(request: NSURLRequest) {
		webView.loadRequest(request)
	}

	public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		self.rectFromId("mobile") { rect in
			var frame = rect
			println(frame.origin)
			self.webView.scrollView.setContentOffset(frame.origin, animated: false)
			println(self.webView.scrollView.contentOffset)
			frame.origin = CGPointZero
			self.webView.frame = frame
		}
	}
}
