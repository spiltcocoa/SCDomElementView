//
//  ViewController.swift
//  iOS Example
//
//  Created by Jeff Boek on 5/21/15.
//  Copyright (c) 2015 spiltcocoa. All rights reserved.
//

import UIKit
import SCDomElementView

class ViewController: UIViewController {

	@IBOutlet weak var elementView: SCDomElementView!

	override func viewDidLoad() {
		super.viewDidLoad()
		let url = "http://192.168.1.30:3000/snapshots/80611367-d48e-4136-b82c-95e6957b5703"
		//f59274fb-55b7-45ad-853d-7e69aac3331e" //
		if let nsUrl = NSURL(string: url) {
			let request = NSMutableURLRequest(URL: nsUrl, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 30)
			request.setValue("f28f3d351d03e881478ef0f3aae47113", forHTTPHeaderField: "OPAL-AUTH-TOKEN")

			elementView.showSelector("mobile", withRequest: request)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

