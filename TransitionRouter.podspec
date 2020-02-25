Pod::Spec.new do |s|
  s.name             = "TransitionRouter"
  s.version          = "0.2.1"
  s.summary          = "Framework for custom transition in iOS"

  s.homepage         = "https://github.com/artemnovichkov/TransitionRouter"
  s.license          = 'MIT'
  s.author           = { "Artem Novichkov" => "novichkoff93@gmail.com" }
  s.source           = { :git => "https://github.com/artemnovichkov/TransitionRouter.git", :tag => s.version.to_s }
  
  s.ios.deployment_target  = '11.0'
  s.ios.frameworks         = 'UIKit', 'Foundation'

  s.requires_arc = true

  s.source_files = 'Sources/*.swift'
end
