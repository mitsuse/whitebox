platform :ios, '9.0'
swift_version = '3.1'
use_frameworks!

pod 'SwiftLint', '~> 0.18.1'

def pod_whitebox
  pod 'PromiseKit', '~> 4.2'
end

def pod_test
  pod 'Quick', '~> 1.1.0'
  pod 'Nimble', '~> 6.1.0'
end

target 'Whitebox' do
  pod_whitebox
end

target 'WhiteboxTests' do
  pod_whitebox
  pod_test
end
