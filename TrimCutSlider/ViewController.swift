import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var LeftNoobView: UIView!
    @IBOutlet weak var RightNoobView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        guard let boundaryView = gestureView.superview else {
            return
        }
        
        let boundaryFrame = boundaryView.bounds
                
        var newCenter = CGPoint(
            x: gestureView.center.x + translation.x,
            y: boundaryView.bounds.midY
        )
        
        let halfWidth = gestureView.bounds.width / 2
        let halfHeight = gestureView.bounds.height / 2
        
        // Ensure the image stays inside the boundary view
        newCenter.x = max(halfWidth, min(newCenter.x, boundaryFrame.width - halfWidth))
        
        // Prevent the noobs from crossing each other
        if gestureView == LeftNoobView {
            newCenter.x = min(newCenter.x, RightNoobView.center.x - halfWidth * 2)
        } else if gestureView == RightNoobView {
            newCenter.x = max(newCenter.x, LeftNoobView.center.x + halfWidth * 2)
        }
        
        gestureView.center = newCenter
        
        gesture.setTranslation(.zero, in: view)
    }
}

