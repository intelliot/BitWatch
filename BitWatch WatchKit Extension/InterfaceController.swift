import WatchKit
import Foundation
import BitWatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    let tracker = Tracker()
    var updating = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        updatePrice(tracker.cachedPrice())
    }

    // Similar to viewWillAppear on iOS
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        update()
    }
    
    @IBAction func refreshTapped() {
        update()
    }
    
    private func updatePrice(price: NSNumber) {
        priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
    }
    
    private func update() {
        if !updating {
            updating = true
            let originalPrice = tracker.cachedPrice()
            tracker.requestPrice { (price, error) -> () in
                if error == nil {
                    self.updatePrice(price!)
                }
                self.updating = false
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
