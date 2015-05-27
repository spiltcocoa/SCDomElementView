//
//  SCDomElementView.swift
//  SCDomElementView
//
//  Created by Jeff Boek on 5/21/15.
//  Copyright (c) 2015 spiltcocoa. All rights reserved.
//

import UIKit

public enum SCDomElementLifecycleEvent {
	case Start
	case Finish
	case Failure
}

public protocol SCDomElementViewDelegate: class {
	func didCompleteLifecycleEvent(event: SCDomElementLifecycleEvent)
}

public class SCDomElementView: UIView, UIWebViewDelegate {

	public let webView = UIWebView()
	public weak var delegate: SCDomElementViewDelegate?
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
		webView.delegate = self
		webView.userInteractionEnabled = false

		addSubview(webView)
	}

	private func rectFromId(id: String, callback: (CGRect) -> ()) {
		var jsString = "function f(){ var r = document.getElementById('\(id)').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();"

		if let result = webView.stringByEvaluatingJavaScriptFromString(jsString) {
			let rect = CGRectFromString(result)

			callback(rect)
		} else {
			delegate?.didCompleteLifecycleEvent(.Failure)
		}

	}

	public func showSelector(selector: String, withRequest request: NSURLRequest) {
		self.selector = selector
		delegate?.didCompleteLifecycleEvent(.Start)
		webView.loadRequest(request)
	}

	public func webViewDidFinishLoad(webView: UIWebView) {
		if let selector = selector {
			self.rectFromId(selector) { rect in
				var frame = rect
				self.webView.scrollView.contentInset = UIEdgeInsets(top: -frame.origin.y, left: -frame.origin.x, bottom: (frame.origin.y + frame.size.height), right: (frame.origin.x + frame.size.width))

				frame.origin = CGPointZero
				self.frame = frame
				self.webView.frame = frame

				self.delegate?.didCompleteLifecycleEvent(.Finished)
			}
		}
	}
}
