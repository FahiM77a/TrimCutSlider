import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var LeftNoobView: UIView!
    @IBOutlet weak var RightNoobView: UIView!
    
    private var isMovingRange = false // Flag to track if the range is being moved
    private var initialLeftPosition: CGFloat = 0 // Initial position of the left noob
    private var initialRightPosition: CGFloat = 0 // Initial position of the right noob
    private var initialTouchPosition: CGFloat = 0 // Initial touch position
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add a pan gesture recognizer for moving the range
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        guard let boundaryView = LeftNoobView.superview else { return }
        let boundaryFrame = boundaryView.bounds
        
        let halfWidth = LeftNoobView.bounds.width / 2
        
        switch gesture.state {
        case .began:
            // Determine if the user is tapping within the selected area
            let location = gesture.location(in: view)
            print("Location: \(location)")
            let leftPosition = LeftNoobView.center.x
            let rightPosition = RightNoobView.center.x
            
            if location.x > leftPosition && location.x < rightPosition {
                // User is tapping within the selected area; start moving the range
                isMovingRange = true
                initialLeftPosition = LeftNoobView.center.x
                initialRightPosition = RightNoobView.center.x
                initialTouchPosition = location.x
            } else if location.x <= leftPosition {
                // User is tapping on or near the left noob
                isMovingRange = false
                initialLeftPosition = LeftNoobView.center.x
            } else if location.x >= rightPosition {
                // User is tapping on or near the right noob
                isMovingRange = false
                initialRightPosition = RightNoobView.center.x
            }
        case .changed:
            // Handle movement based on the gesture state
            if isMovingRange {
                // Move the entire range
                let newTouchPosition = gesture.location(in: view).x
                let deltaX = newTouchPosition - initialTouchPosition
                
                var newLeftPosition = initialLeftPosition + deltaX
                var newRightPosition = initialRightPosition + deltaX
                
                // Ensure the range stays within the bounds of the superview
                newLeftPosition = max(halfWidth, min(newLeftPosition, boundaryFrame.width - halfWidth))
                newRightPosition = max(halfWidth, min(newRightPosition, boundaryFrame.width - halfWidth))
                
                // Update the positions of the noobs
                LeftNoobView.center.x = newLeftPosition
                RightNoobView.center.x = newRightPosition
            } else {
                // Handle individual noob movement
                let location = gesture.location(in: view)
                let leftPosition = LeftNoobView.center.x
                let rightPosition = RightNoobView.center.x
                
                if location.x <= leftPosition {
                    // Move the left noob
                    var newCenter = CGPoint(
                        x: LeftNoobView.center.x + translation.x,
                        y: boundaryView.bounds.midY
                    )
                    
                    // Ensure the left noob stays within bounds
                    newCenter.x = max(halfWidth, min(newCenter.x, boundaryFrame.width - halfWidth))
                    
                    // Prevent the left noob from crossing the right noob
                    newCenter.x = min(newCenter.x, RightNoobView.center.x - halfWidth * 2)
                    
                    LeftNoobView.center = newCenter
                } else if location.x >= rightPosition{
                    
                    // Move the right noob
                    var newCenter = CGPoint(
                        x: RightNoobView.center.x + translation.x,
                        y: boundaryView.bounds.midY
                    )
                    
                    // Ensure the right noob stays within bounds
                    newCenter.x = max(halfWidth, min(newCenter.x, boundaryFrame.width - halfWidth))
                    
                    // Prevent the right noob from crossing the left noob
                    newCenter.x = max(newCenter.x, LeftNoobView.center.x + halfWidth * 2)
                    
                    RightNoobView.center = newCenter
                }
            }
            
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            // Reset flags when the gesture ends
            isMovingRange = false
        
        default:
            break
        }
    }
}

