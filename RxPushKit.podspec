#
# Be sure to run `pod lib lint RxPushKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxPushKit'
  s.version          = '0.1.7'
  s.summary          = 'Reactive extension for PushKit.'

  s.description      = <<-DESC
  RxPushKit is an RxSwift reactive extension for PushKit.
  Requires Xcode 10.2 with Swift 5.0.
                       DESC

  s.homepage         = 'https://github.com/pawelrup/RxPushKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paweł Rup' => 'pawelrup@lobocode.pl' }
  s.source           = { :git => 'https://github.com/pawelrup/RxPushKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
  s.swift_version = '5.0'

  s.source_files = 'RxPushKit/Classes/**/*'
  s.pod_target_xcconfig =  {
	  'SWIFT_VERSION' => '5.0',
  }
  
  s.frameworks = 'PushKit'
  s.dependency 'RxSwift', '~> 4.5.0'
  s.dependency 'RxCocoa', '~> 4.5.0'
end
