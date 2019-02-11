//
//  RepoListViewController.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import UIKit
import SDWebImage

extension CellIdentifier {
    static let repositoryCell = "RepoCell"
}

class RepoListViewController: UIViewController {
    static let storyboardID = "RepoListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var presenter: RepoListViewOutput?
    private var repositories = [RepositoryViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    private func setupUI() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Repository Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: CellIdentifier.repositoryCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = activityIndicator
    }
}

extension RepoListViewController: RepoListView {
    func clearSelection() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func setRepositories(_ repositories: [RepositoryViewModel]) {
        self.repositories = repositories
        tableView.backgroundView = nil
        tableView.reloadData()
    }
    
    func appendRepositories(_ repositories: [RepositoryViewModel]) {
        let oldNumberOfRows = self.repositories.count
        let newNumberOfRows = oldNumberOfRows + repositories.count
        let rowsToInsert = (oldNumberOfRows..<newNumberOfRows).map{IndexPath(row: $0, section: 0)}
        self.repositories.append(contentsOf: repositories)
        tableView.beginUpdates()
        tableView.insertRows(at: rowsToInsert, with: .automatic)
        tableView.endUpdates()
    }
    
    func displayEmptyResults(placeholder: String) {
        self.repositories = []
        tableView.reloadData()
        placeholderLabel.text = placeholder
        tableView.backgroundView = placeholderLabel
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

extension RepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.repositoryCell) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.titleLabel.text = repository.title
        cell.descriptionLabel.text = repository.description
        cell.starsCountLabel.text = "\(repository.starsCount) stars"
        cell.ownerNameLabel.text = repository.ownerName
        cell.ownerImageView.sd_setImage(with: URL(string: repository.ownerImageUrl), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
}

extension RepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.didScrollToIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRepository(at: indexPath.row)
    }
}

extension RepoListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didChangeSearchText(searchController.searchBar.text ?? "")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        presenter?.didChangeSearchText("")
    }
}
