
import UIKit
import CoreData

class QuestionVC: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberOfTimesLabel: UILabel!
    @IBOutlet var answerBtns: [UIButton]!
    
    
    
    var numberOfCorrectAnswers = 0
    var questions = [Question]()
    var filteredquestions = [Question]()
    var currentQuestionIndex = 0
    var difficulty = QuestionDifficulty.easy
    
    func setupQuestions() {
        
        
        questions.append(Question(text: "OS computer abbreviation usually means ?", answers: [
                                    Answer(text: "Order of Significance", correct: false),
                                    Answer(text: "Open Software", correct: false),
                                    Answer(text: "Operating System", correct: true),
                                    Answer(text: "Optical Sensor", correct: false)], difficulty: .easy))
        questions.append(Question(text:"What does GPS stand for ?", answers: [
                                    Answer(text: "Global Position Service", correct: false),
                                    Answer(text: "Global Positioning System", correct: true),
                                    Answer(text: "General Position Service", correct: false),
                                    Answer(text: "General Pointing Service", correct: false)], difficulty: .easy))
        questions.append(Question(text: "Who was the founder of google", answers: [
                                    Answer(text: "Sundar Pichai", correct: false),
                                    Answer(text: "Erik Andersson", correct: false),
                                    Answer(text: "Larry Page and Sergey Brin", correct: true),
                                    Answer(text: "Sundar Pichai and Erik Andersson", correct: false)], difficulty: .easy))
        questions.append(Question(text: "'.MOV' extension refers usually to what kind of file?", answers: [
                                    Answer(text: "Image file", correct: false),
                                    Answer(text: "Animation/movie file", correct: true),
                                    Answer(text: "Audio file", correct: false),
                                    Answer(text: "MS Office document", correct: false)], difficulty: .easy))
        questions.append(Question(text: "In what year was the '@' chosen for its use in e-mail addresses?", answers: [
                                    Answer(text: "1976", correct: false),
                                    Answer(text: "1972", correct: true),
                                    Answer(text: "1980", correct: false),
                                    Answer(text: "1984", correct: false)], difficulty: .hard))
        questions.append(Question(text: "The maturity levels used to measure a process are ?", answers: [
                                    Answer(text: "Primary, Secondary, Defined, Managed, Optimized", correct: false),
                                    Answer(text: "Initial, Repeatable, Defined, Managed, Optimized", correct: true),
                                    Answer(text: "Initial, Stating, Defined, Managed, Optimized", correct: false),
                                    Answer(text: "None of above", correct: false)], difficulty: .hard))
        
        questions.append(Question(text: "Who developed Yahoo?", answers: [
                                    Answer(text: "Dennis Ritchie & Ken Thompson", correct: false),
                                    Answer(text: "David Filo & Jerry Yang", correct: false),
                                    Answer(text: "Vint Cerf & Robert Kahn", correct: true),
                                    Answer(text: "Steve Case & Jeff Bezos", correct: false)], difficulty: .medium))
        questions.append(Question(text: "What does AC and DC stand for in the electrical field?", answers: [
                                    Answer(text: "Alternating Current and Direct Current", correct: true),
                                    Answer(text: "A Rock Band from Australia", correct: false),
                                    Answer(text: "Average Current and Discharged Capacitor", correct: false),
                                    Answer(text: "Atlantic City and District of Columbia", correct: false)], difficulty: .medium))
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in answerBtns{
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        setupQuestions()
        questions.shuffle()
        filteredquestions = questions.filter{$0.difficulty == difficulty}
        setupViews()
    }
    
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let question = filteredquestions[currentQuestionIndex]
        
        if question.answers[sender.tag].correct{
            sender.backgroundColor = .green
            correctAnswerAlert()
        }else{
            sender.backgroundColor = .red
            wrongAnswerAlert()
        }
    }
    func correctAnswerAlert() {
        numberOfCorrectAnswers += 1
        
        //Alert
        let alert = UIAlertController(title: "Correct Answer!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.resetColorsAndQuestion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func wrongAnswerAlert() {
        //Alert
        let alert = UIAlertController(title: "Wrong Answer!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.resetColorsAndQuestion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func resetColorsAndQuestion() {
        for button in answerBtns{
            button.backgroundColor = .clear
        }
        
        currentQuestionIndex += 1
        setupViews()
    }
    func setupViews() {
        if currentQuestionIndex < filteredquestions.count{
            let question = filteredquestions[currentQuestionIndex]
            
            questionLabel.text = question.text
            
            for (i,answer) in question.answers.enumerated(){
                answerBtns[i].setTitle(answer.text, for: .normal)
            }
            
            saveQuestionAndNumberOfTimes()
            
        }else{
            // save scrore in core data
            let result = Results(context: CoreStack.shared.persistentContainer.viewContext)
            result.date = Date()
            result.numberOfQuestions = Int16(filteredquestions.count)
            result.numberOfAnswersCorrect = Int16(numberOfCorrectAnswers)
            result.difficulty = Int16(difficulty.rawValue)
            CoreStack.shared.saveContext()
            
            if let vc = storyboard?.instantiateViewController(identifier: "ResultsVC"){
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func saveQuestionAndNumberOfTimes() {
        let question = filteredquestions[currentQuestionIndex]
        
        CoreStack.shared.fetch(CDQuestion.self) { cdQuestions in
            for cdQuestion in cdQuestions{
                if cdQuestion.text == question.text{
                    cdQuestion.numberOfTime?.numberOfTime = (cdQuestion.numberOfTime?.numberOfTime ?? 0) + 1
                    self.numberOfTimesLabel.text = "Number of times: \(cdQuestion.numberOfTime?.numberOfTime ?? 0)"
                }
            }
            if cdQuestions.count == 0{
                self.saveQuestions()
            }
            CoreStack.shared.saveContext()
        }
        
        
    }
    func saveQuestions() {
        for question in filteredquestions{
            let questionToSave = CDQuestion(context: CoreStack.shared.persistentContainer.viewContext)
            let numberOfTime = NumberOfTime(context: CoreStack.shared.persistentContainer.viewContext)
            questionToSave.text = question.text
            numberOfTime.numberOfTime = 0
            questionToSave.numberOfTime = numberOfTime
            CoreStack.shared.saveContext()
        }
    }
}
