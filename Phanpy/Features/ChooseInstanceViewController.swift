//
//  ChooseInstanceViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/25.
//

import SafariServices
import UIKit

final class ChooseInstanceViewController: UIViewController {
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default.then {
        let token = """
            """
        $0.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    })

    private lazy var tableView = UITableView().then {
        $0.dataSource = self
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = UISearchController(searchResultsController: nil).then {
            $0.hidesNavigationBarDuringPresentation = false
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.delegate = self
        }
    }
}

extension ChooseInstanceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ChooseInstanceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var urlComponent = URLComponents(string: "https://instances.social/api/1.0/instances/search") else {
            fatalError()
        }

        urlComponent.queryItems = [URLQueryItem(name: "q", value: searchBar.text)]
        guard let url = urlComponent.url else {
            fatalError()
        }

        urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard
                let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data)
            else {
                return
            }

            print(jsonObject)
        }.resume()
    }
}
