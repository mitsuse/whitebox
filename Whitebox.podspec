Pod::Spec.new do |spec|
  spec.name = 'Whitebox'
  spec.version = '0.1.0'
  spec.license = { :type => 'MIT' }
  spec.homepage = 'https://github.com/mitsuse/whitebox'
  spec.authors = { 'Tomoya Kose' => 'tomoya@mitsuse.jp' }
  spec.summary = 'A container of application state with asynchronous action queue.'
  spec.source = { :git => 'https://github.com/mitsuse/whitebox.git' }
  spec.source_files = 'Sources/**/*.swift'
  spec.framework = 'SystemConfiguration'
  spec.dependency 'PromiseKit', '~> 4.2'
end
