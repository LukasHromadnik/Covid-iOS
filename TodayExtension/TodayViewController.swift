//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet private var numberOfCasesLabel: UILabel! {
        didSet {
            numberOfCasesLabel.font = .preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet private var numberOfCasesValueLabel: UILabel! {
        didSet {
            numberOfCasesValueLabel.font = .preferredFont(forTextStyle: .title1)
        }
    }
    @IBOutlet private var numberOfTestsLabel: UILabel! {
        didSet {
            numberOfTestsLabel.font = .preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet private var numberOfTestsValueLabel: UILabel! {
        didSet {
            numberOfTestsValueLabel.font = .preferredFont(forTextStyle: .title1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        numberOfCasesValueLabel.text = "--"
        numberOfTestsValueLabel.text = "--"
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
