import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var imageFive: UIImageView!
    @IBOutlet weak var imageSix: UIImageView!
    @IBOutlet weak var imageSeven: UIImageView!
    @IBOutlet weak var imageEight: UIImageView!
    @IBOutlet weak var imageNine: UIImageView!
    
    var imageViewList: [UIImageView] = []
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highestScore: UILabel!
    var timerCreateKenny = Timer()
    var timerRemoveKenny = Timer()
    var timerGame = Timer()
    var counter = 0
    var score = 0
    var storedScore = UserDefaults.standard.object(forKey: "score") ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highestScore.text = "Highest Score: \(storedScore)"
        imageViewList = [imageOne, imageTwo, imageThree, imageFour, imageFive, imageSix, imageSeven, imageEight, imageNine]
        randomKenny()
    }
    
    func randomKenny(){
        counter = 10
        timerCreateKenny = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        timerGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerGameOver), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc(){
        for i in imageViewList{
            i.image = UIImage(named: "")
            i.isUserInteractionEnabled = false
        }
        let gestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(catchKenny(sender:)))
        imageViewList[gestureRecognizer.randomInt].image = UIImage(named: "kenny-cutout")
        imageViewList[gestureRecognizer.randomInt].isUserInteractionEnabled = true
        imageViewList[gestureRecognizer.randomInt].addGestureRecognizer(gestureRecognizer)
    }

    @objc func catchKenny(sender: CustomTapGestureRecognizer){
        score = score + 1
        scoreLabel.text = "Score: \(score)"
        imageViewList[sender.randomInt].image = UIImage(named: "")
        imageViewList[sender.randomInt].isUserInteractionEnabled = false
    }
    
    @objc func timerGameOver(){
        timeLabel.text = "Time: \(counter)"
        counter = counter - 1
        if counter == 0{
            if score > storedScore as! Int{
                UserDefaults.standard.set(score, forKey: "score")
            }
            timerGame.invalidate()
            timeLabel.text = "Time is over"
            timerCreateKenny.invalidate()
            gameOver()
        }
        
        func gameOver(){
            let alert = UIAlertController(title: "Time is over!", message: "Your score: \(score)", preferredStyle: UIAlertController.Style.alert)
            let exitbutton = UIAlertAction(title: "Exit", style: UIAlertAction.Style.default){_ in
                exit(0)
            }
            let resetButton = UIAlertAction(title: "Reset", style: UIAlertAction.Style.default){_ in
                UserDefaults.standard.removeObject(forKey: "score")
                self.highestScore.text = "Highest Score: 0"
                self.score = 0
                self.counter = 10
                self.scoreLabel.text = "Score: 0"
                self.timerCreateKenny = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerFunc), userInfo: nil, repeats: true)
                self.timerGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerGameOver), userInfo: nil, repeats: true)
            }
            let tryAgainButton = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default){ _ in
                self.counter = 10
                self.scoreLabel.text = "Score: 0"
                if self.score > self.storedScore as! Int{
                    self.highestScore.text = "Highest Score: \(self.score)"
                    UserDefaults.standard.set(self.score, forKey: "score")
                }
                self.score = 0
                self.timerCreateKenny = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerFunc), userInfo: nil, repeats: true)
                self.timerGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerGameOver), userInfo: nil, repeats: true)
                
            }
            alert.addAction(exitbutton)
            alert.addAction(tryAgainButton)
            alert.addAction(resetButton)
            self.present(alert, animated: true)
        }
    }
}

