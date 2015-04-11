import WatchKit
import Foundation
import BitWatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var lastUpdatedLabel: WKInterfaceLabel!
    let tracker = Tracker()
    var updating = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        updatePrice(tracker.cachedPrice())
        image.setHidden(true)
        updateDate(tracker.cachedDate())
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
    
    private func updateDate(date: NSDate) {
        self.lastUpdatedLabel.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
    }
    
    private func update() {
        if !updating {
            updating = true
            let originalPrice = tracker.cachedPrice()
            tracker.requestPrice { (price, error) -> () in
                if error == nil {
                    self.updatePrice(price!)
                    self.updateDate(NSDate())
                    self.updateImage(originalPrice, newPrice: price!)
                }
                self.updating = false
            }
        }
    }
    
    private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
        if originalPrice.isEqualToNumber(newPrice) {
            image.setHidden(true);
        } else {
            if newPrice.doubleValue > originalPrice.doubleValue {
                image.setImageNamed("Up")
            } else {
                image.setImageNamed("Down")
            }
            image.setHidden(false)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
