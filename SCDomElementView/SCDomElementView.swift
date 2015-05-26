//
//  SCDomElementView.swift
//  SCDomElementView
//
//  Created by Jeff Boek on 5/21/15.
//  Copyright (c) 2015 spiltcocoa. All rights reserved.
//

import UIKit
import WebKit

public protocol SCDomElementViewDelegate {
	func domElementViewDidStartRequest(view: SCDomElementView)
	func domElementViewDidFinishRequest(view: SCDomElementView)
	func domElementView(view: SCDomElementView, DidFinishRequestWithError: NSError)
}

public class SCDomElementView: UIView, WKNavigationDelegate, UIScrollViewDelegate {

	public let webView: WKWebView = {
		let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'initial-scale=1.0'); document.getElementsByTagName('head')[0].appendChild(meta);"
		let script = WKUserScript(source: js, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)

		let controller = WKUserContentController()
		controller.addUserScript(script)

		let config = WKWebViewConfiguration()
		config.userContentController = controller

		let webView = WKWebView(frame: CGRectZero, configuration: config)
		webView.userInteractionEnabled = false

		return webView
	}()

	public var delegate: SCDomElementViewDelegate?
	private var selector: String?

	public override init(frame: CGRect) {
		super.init(frame: frame)

		configure()
	}

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		configure()
	}

	private func configure() {
		webView.navigationDelegate = self
		webView.scrollView.delegate = self
		webView.scrollView.bounces = false

		addSubview(webView)
	}

	private func rectFromId(id: String, callback: (CGRect) -> ()) {
		var javascript = "function f(){ var r = document.getElementById('\(id)').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";

		webView.evaluateJavaScript(javascript) { result, error in
			if let error = error {
				self.delegate?.domElementView(self, DidFinishRequestWithError: error)

				return
			}

			if let result = result as? String {
				let rect = CGRectFromString(result)

				callback(rect)
			}
		}
	}

	public func showSelector(selector: String, withRequest request: NSURLRequest) {
		self.selector = selector
		delegate?.domElementViewDidStartRequest(self)
		webView.loadRequest(request)
	}

	public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		if let selector = selector {
			self.rectFromId(selector) { rect in
				var frame = rect
				self.webView.scrollView.contentInset = UIEdgeInsets(top: -frame.origin.y, left: -frame.origin.x, bottom: (frame.origin.y + frame.size.height), right: (frame.origin.x + frame.size.width))

				frame.origin = CGPointZero
				self.frame = frame
				self.webView.frame = frame

				self.delegate?.domElementViewDidFinishRequest(self)
			}
		}
	}
}
