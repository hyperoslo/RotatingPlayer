import UIKit
import MediaPlayer

public protocol VideoControllerDelegate {
  func videoControllerWasDismissed()
}

  public class VideoController: UIViewController {

  public var isPresented = true
  public var delegate: VideoControllerDelegate?
  public var player: MPMoviePlayerController

  public init(url: NSURL, delegate: VideoControllerDelegate? = nil) {
    self.delegate = delegate
    self.player = MPMoviePlayerController(contentURL: url)
    super.init(nibName: nil, bundle: nil)
  }

  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
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

  override public func viewDidLayoutSubviews() {
    player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
  }

  override public func viewDidAppear(animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(true,
      withAnimation: .Fade)
  }

  override public func viewDidDisappear(animated: Bool) {
    delegate?.videoControllerWasDismissed()
  }

  override public func viewWillDisappear(animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(false,
      withAnimation: .Fade)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}