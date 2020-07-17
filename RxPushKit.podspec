Pod::Spec.new do |s|
  s.name             = 'RxPushKit'
  s.version          = '0.1.8'
  s.summary          = 'Reactive extension for PushKit.'

  s.description      = <<-DESC
  RxPushKit is an RxSwift reactive extension for PushKit.
  Requires Xcode 12.0 with Swift 5.3.
                       DESC

  s.homepage         = 'https://github.com/pawelrup/RxPushKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paweł Rup' => 'pawelrup@lobocode.pl' }
  s.source           = { :git => 'https://github.com/pawelrup/RxPushKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.swift_version = '5.3'

  s.source_files = 'Sources/RxPushKit/**/*'

  s.frameworks = 'PushKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
