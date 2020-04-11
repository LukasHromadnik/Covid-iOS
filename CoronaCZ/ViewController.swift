//
//  ViewController.swift
//  CoronaCZ
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private weak var casesBarChart: BasicBarChart!
    private weak var testsBarChart: BasicBarChart!

    private var refreshBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle

    override func loadView() {
        let view = MainView()
        casesBarChart = view.casesBarChart
        testsBarChart = view.testsBarChart
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("title", comment: "")
        refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBarButtonTapped))
        navigationItem.rightBarButtonItem = refreshBarButtonItem

        setDarkAppIconIfPossible()

        refreshData()
    }

    // MARK: - Actions

    @objc
    private func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        let loadingView = UIActivityIndicatorView(style: .medium)
        loadingView.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingView)
        loadingView.startAnimating()

        refreshData()
    }

    // MARK: - Private methods

    private func refreshData() {
        let group = DispatchGroup()

        let testsPath = "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19/testy.min.json"
        group.enter()
        fetch(path: testsPath, type: TestsContainer.self) { [weak self] testsContainer in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.show(testsContainer.data, in: self.testsBarChart)
                group.leave()
            }
        }

        let casesPath = "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19/nakaza.min.json"
        group.enter()
        fetch(path: casesPath, type: [Case].self) { [weak self] cases in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.show(cases, in: self.casesBarChart)
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.navigationItem.rightBarButtonItem = self?.refreshBarButtonItem
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

    private func setDarkAppIconIfPossible() {
        // Without the delay the alternate icon is not working
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let hasDarkMode = self?.traitCollection.userInterfaceStyle == .dark
            let hasDefaultIcon = UIApplication.shared.alternateIconName == nil

            switch (hasDarkMode, hasDefaultIcon) {
            case (true, true):
                UIApplication.shared.setAlternateIconName("AppIcon-DarkMode")
            case (false, false):
                UIApplication.shared.setAlternateIconName(nil)
            default:
                break
            }
        }
    }
}
