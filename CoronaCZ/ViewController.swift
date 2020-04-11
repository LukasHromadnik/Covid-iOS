//
//  ViewController.swift
//  CoronaCZ
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit

final class ViewControllerView: UIView {
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
        casesTitleLabel.text = "Případy"
        casesTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(casesTitleLabel)
        casesTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let casesBarChart = BasicBarChart()
        addSubview(casesBarChart)
        casesBarChart.translatesAutoresizingMaskIntoConstraints = false
        self.casesBarChart = casesBarChart

        let testsTitleLabel = UILabel()
        testsTitleLabel.text = "Testy"
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

final class ViewController: UIViewController {
    private weak var casesBarChart: BasicBarChart!
    private weak var testsBarChart: BasicBarChart!
    
    // MARK: - Lifecycle

    override func loadView() {
        let view = ViewControllerView()
        casesBarChart = view.casesBarChart
        testsBarChart = view.testsBarChart
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Koronavirus"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBarButtonTapped))

        refreshData()
    }

    // MARK: - Actions

    @objc
    private func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        refreshData()
    }

    // MARK: - Private methods

    private func refreshData() {
        let testsPath = "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19/testy.min.json"
        fetch(path: testsPath, type: TestsContainer.self) { [weak self] testsContainer in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.show(testsContainer.data, in: self.testsBarChart)
            }
        }

        let casesPath = "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19/nakaza.min.json"
        fetch(path: casesPath, type: [Case].self) { [weak self] cases in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.show(cases, in: self.casesBarChart)
            }
        }
    }

    private func fetch<T>(path: String, type: T.Type, completion: @escaping (T) -> Void) where T: Decodable {
        print("⬆️ \(path)")
        let task = URLSession.shared.dataTask(with: URL(string: path)!) { [weak self] data, response, error in
            print("⬇️ \(path)")
            if let error = error {
                let alert = UIAlertController(title: "Chyba", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Zavřít", style: .cancel))
                self?.present(alert, animated: true)
                return
            }

            guard let data = data else { assertionFailure(); return }

            let result = try! JSONDecoder().decode(T.self, from: data)
            completion(result)
        }
        task.resume()
    }

    private func show<T>(_ items: [T], in chart: BasicBarChart) where T: CoronaEntry {
        let totalAmountPerDay = items.map { $0.totalDay }.max() ?? 0

        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMM")

        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]

        let entries = items.reversed().enumerated().map { offset, item in
            DataEntry(
                color: colors[offset % colors.count],
                height: Float(item.totalDay) / Float(totalAmountPerDay),
                textValue: "\(item.totalDay)",
                title: formatter.string(from: item.date)
            )
        }

        chart.updateDataEntries(dataEntries: entries, animated: false)
    }
}
