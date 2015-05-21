//
//  SCDomElementView.swift
//  SCDomElementView
//
//  Created by Jeff Boek on 5/21/15.
//  Copyright (c) 2015 spiltcocoa. All rights reserved.
//

import UIKit
import WebKit

public class SCDomElementView: UIView {

	public let scrollView: UIScrollView
	public let webView: WKWebView

	public init(frame: CGRect, request: NSURLRequest) {
		scrollView = UIScrollView(frame: CGRectZero)
		webView = WKWebView()

		super.init(frame: frame)
	}

	public required init(coder aDecoder: NSCoder) {
		scrollView = UIScrollView(frame: CGRectZero)
		webView = WKWebView()

	    super.init(coder: aDecoder)
	}
}
