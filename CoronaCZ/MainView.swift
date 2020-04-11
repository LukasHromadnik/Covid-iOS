//
//  MainView.swift
//  CoronaCZ
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit

final class MainView: UIView {
    weak var casesBarChart: BasicBarChart!
    weak var testsBarChart: BasicBarChart!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBackground

        let casesTitleLabel = UILabel()
        casesTitleLabel.text = NSLocalizedString("chart.cases.title", comment: "")
        casesTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(casesTitleLabel)
        casesTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let casesBarChart = BasicBarChart()
        addSubview(casesBarChart)
        casesBarChart.translatesAutoresizingMaskIntoConstraints = false
        self.casesBarChart = casesBarChart

        let testsTitleLabel = UILabel()
        testsTitleLabel.text = NSLocalizedString("chart.tests.title", comment: "")
        testsTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(testsTitleLabel)
        testsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let testsBarChart = BasicBarChart()
        addSubview(testsBarChart)
        testsBarChart.translatesAutoresizingMaskIntoConstraints = false
        self.testsBarChart = testsBarChart

        NSLayoutConstraint.activate([
            casesTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            casesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            casesTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            casesBarChart.topAnchor.constraint(equalTo: casesTitleLabel.bottomAnchor),
            casesBarChart.leadingAnchor.constraint(equalTo: leadingAnchor),
            casesBarChart.trailingAnchor.constraint(equalTo: trailingAnchor),

            testsTitleLabel.topAnchor.constraint(equalTo: casesBarChart.bottomAnchor, constant: 8),
            testsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            testsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            testsBarChart.topAnchor.constraint(equalTo: testsTitleLabel.bottomAnchor),
            testsBarChart.leadingAnchor.constraint(equalTo: leadingAnchor),
            testsBarChart.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            testsBarChart.trailingAnchor.constraint(equalTo: trailingAnchor),
            testsBarChart.heightAnchor.constraint(equalTo: casesBarChart.heightAnchor)
        ])
    }
}
