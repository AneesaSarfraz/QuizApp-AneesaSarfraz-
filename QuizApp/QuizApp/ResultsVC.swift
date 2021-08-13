

import UIKit
import CoreData
class ResultsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var results = [Results]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        CoreStack.shared.fetch(Results.self) { results in
            self.results = results
            self.tableView.reloadData()
        }
        
    }
    @IBAction func goToHome() {
        if let vc = storyboard?.instantiateViewController(identifier: "home"){
            if let window = UIApplication.shared.windows.first{
                vc.modalPresentationStyle = .fullScreen
                window.rootViewController = vc
            }
        }
    }
    


}
extension ResultsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = results[indexPath.row]
        let difficulty = QuestionDifficulty(rawValue: Int(result.difficulty))
        cell.textLabel?.text = "Your Score \(result.numberOfAnswersCorrect) / \(result.numberOfQuestions) (\(difficulty ?? .easy))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        cell.detailTextLabel?.text = dateFormatter.string(from: result.date ?? Date())
        return cell
    }
}
