import UIKit
import MediaPlayer

protocol VideoControllerDelegate {
  func videoControllerWasDismissed()
}

public class VideoController: UIViewController {

  var isPresented = true
  var delegate: VideoControllerDelegate?
  var player: MPMoviePlayerController

  init(url: NSURL, delegate: VideoControllerDelegate? = nil) {
    self.delegate = delegate
    self.player = MPMoviePlayerController(contentURL: url)
    super.init(nibName: nil, bundle: nil)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    player.view.sizeToFit()
    player.scalingMode = MPMovieScalingMode.AspectFit
    player.fullscreen = true
    player.controlStyle = MPMovieControlStyle.Fullscreen
    player.movieSourceType = MPMovieSourceType.File
    player.repeatMode = MPMovieRepeatMode.One
    player.play()
    self.view.addSubview(player.view)
    subscribe()
  }

  func subscribe() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerDidFinish:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: player)
  }

  func playerDidFinish(player: MPMoviePlayerController) {
    isPresented = false
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  override func viewDidLayoutSubviews() {
    player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
  }

  override func viewDidAppear(animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(true,
      withAnimation: .Fade)
  }

  override func viewDidDisappear(animated: Bool) {
    delegate?.videoControllerWasDismissed()
  }

  override func viewWillDisappear(animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(false,
      withAnimation: .Fade)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}