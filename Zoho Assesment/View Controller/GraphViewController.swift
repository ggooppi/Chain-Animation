//
//  GraphViewController.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 05/01/20.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var gestureView: UILabel!
    
    let cardHeight:CGFloat = 430
    let cardHandleAreaHeight:CGFloat = 170
    
    var cardVisible = false
    
    weak var delegate: UIViewAnimationHandler?
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var callback: ((String) -> Void)?
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["plant1", "plant2", "plant3", "plant4", "plant5", "plant6", "plant7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupChart()
    }
    
    func setupUI() {
        
        // 1
        view.backgroundColor = .clear
        // 2
        let blurEffect = UIBlurEffect(style: .light)
        // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        let tapGestureRecognizerHandel = UITapGestureRecognizer(target: self, action: #selector(WateringViewController.handleCardHandelTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WateringViewController.handleCardPan(recognizer:)))
        
        gestureView.addGestureRecognizer(tapGestureRecognizerHandel)
        gestureView.addGestureRecognizer(panGestureRecognizer)
        
        self.view.layer.cornerRadius = 12
    }
    
    func setupChart() {
        lineChart.rightAxis.enabled = false
        lineChart.drawGridBackgroundEnabled = false
        
        lineChart.chartDescription?.enabled = false
        
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = false
        lineChart.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
        lineChart.legend.enabled = false
        
        lineChart.leftAxis.enabled = false
        lineChart.leftAxis.spaceBottom = 0.4
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        
        
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        
        let count = Int(arc4random_uniform(20) + 3)
        let values = (0...count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 =  LineChartDataSet(entries: values)
        let data = LineChartData(dataSet: set1)
        
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true // Draw the Gradient
        set1.drawIconsEnabled = false
        set1.setColor(.themeColor)
        set1.setCircleColor(.themeColor)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.mode = .cubicBezier
        
        lineChart.animate(yAxisDuration: 0.5, easingOption: .easeOutSine)
        lineChart.data = data
    }
    
    @objc
    func handleCardHandelTap(recognzier:UITapGestureRecognizer) {
        guard let delegate = self.delegate else {
            return
        }
        switch recognzier.state {
        case .ended:
            delegate.animateTransitionIfNeeded(givenView: ViewName.top.rawValue, cardVisible: cardVisible, state: nextState.rawValue, duration: 0.9, expandHeight: cardHeight, collapseHeight: cardHandleAreaHeight, blurBackground: false) {[weak self] (status) in
                self?.cardVisible = status
            }
        //            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        guard let delegate = self.delegate else {
            return
        }
        switch recognizer.state {
        case .began:
            delegate.startInteractiveTransition(view: ViewName.top.rawValue, cardVisible: cardVisible, state: nextState.rawValue, duration: 0.9, expandHeight: cardHeight, collapseHeight: cardHandleAreaHeight, blurBackground: false) {[weak self] (status) in
                self?.cardVisible = status
            }
        case .changed:
            let translation = recognizer.translation(in: self.view)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            delegate.updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            delegate.continueInteractiveTransition()
        default:
            break
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GraphViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GraphCollectionViewCell
        cell.plantImageView.image = UIImage(named: items[indexPath.row])
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupChart()
        if let callback = self.callback{
            callback(items[indexPath.row])
        }
    }
    
    
}


