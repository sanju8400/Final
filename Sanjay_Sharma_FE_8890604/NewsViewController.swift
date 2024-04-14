//
//  NewsViewController.swift
//  Sanjay_Sharma_FE_8890604
//
//  Created by user238626 on 4/13/24.
//

import UIKit
import CoreLocation


class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var newsArticles: [NewsArticle] = []
    private let newsViewModel = NewsViewModel()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set table view data source
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Explicitly set the row height
        tableView.rowHeight = 170
        
        // Fetch news data
        fetchNews(for: "Waterloo")
        // Set the articles handler
        newsViewModel.articlesHandler = { [weak self] articles in
            self?.newsArticles = articles
            // Reload the table view to reflect changes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        // Create an alert controller
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your new destination here", preferredStyle: .alert)
        
        // Add a text field to the alert controller
        alertController.addTextField { textField in
            textField.placeholder = "City"
        }
        
        // Create a "Confirm" action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let city = textField.text else { return }
            self?.fetchNews(for: city)
        }
        alertController.addAction(confirmAction)
        
        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Implement UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTabTableViewCell
        let article = newsArticles[indexPath.row]
        
        // Customize the appearance of the cell
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 8.0
        
        // Configure the cell with article data
        cell.title.text = article.title
        cell.news.text = article.description
        cell.author.text = "Author: \(article.author)"
        cell.source.text = "Source: \(article.source)"
        
        return cell
    }
    
    
    // Method to fetch news articles
    func fetchNews(for city: String) {
        newsViewModel.fetchNews(for: city)
    }
    
}

