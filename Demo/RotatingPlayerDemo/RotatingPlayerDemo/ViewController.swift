import UIKit
import RotatingPlayer

class ViewController: UIViewController {

  @IBAction func buttonPressed(sender: UIButton) {
    let videoController = RotatingPlayer(url: NSURL(string: "http://sample-videos.com/video/mp4/720/big_buck_bunny_720p_50mb.mp4")!, delegate: nil)
    presentViewController(videoController, animated: true, completion: nil)
  }
}

