
import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var difficultySlider: UISlider!

    var difficulty = QuestionDifficulty.medium
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.view.backgroundColor = .clear
        
        CoreStack.shared.fetch(Results.self) { results in
            let scores = results.map{$0.numberOfAnswersCorrect}
            self.scoreLabel.text = "High Score: " + (scores.max()?.description ?? "")
        }
        
    }
    
    @IBAction func startBtnTabbed() {
        //Change the start screen
        
        if let vc = storyboard?.instantiateViewController(identifier: "QuestionVC") as? QuestionVC{
            vc.difficulty = difficulty
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    let step: Float = 1
    @IBAction func difficultyDidChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
          sender.value = roundedValue
        switch sender.value {
        case 0:
            difficultyLabel.text = "Easy"
            difficulty = .easy
        case 1:
            difficultyLabel.text = "Medium"
            difficulty = .medium
        case 2:
            difficultyLabel.text = "Hard"
            difficulty = .hard
        default:
            break
        }
    }
    
}
