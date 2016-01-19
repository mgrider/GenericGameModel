Pod::Spec.new do |s|
  s.name                   = "GenericGameModel"
  s.version                = "4.0.2"
  s.summary                = "A collection of classes for MVC 2D game development in iOS."
  s.homepage               = "https://github.com/mgrider/GenericGameModel"
  s.license                = 'MIT'
  s.author                 = "Martin Grider"
  s.source                 = { :git => "https://github.com/mgrider/GenericGameModel.git", :tag => s.version.to_s }
  s.platform               = :ios, '8.4'
  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target  = '6.1'
  s.requires_arc           = true
  s.source_files           = 'GenericGameModel'
  s.frameworks             = 'QuartzCore', 'UIKit'
  s.dependency 'BaseModel'
end
