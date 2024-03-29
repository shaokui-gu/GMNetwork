Pod::Spec.new do |s|
  s.name         = "GMNetwork"
  s.version      = "0.0.8"
  s.summary      = "A network tool for GM"
  s.homepage     = "https://github.com/shaokui-gu/GMNetwork"
  s.license      = 'MIT'
  s.author       = { 'gushaokui' => 'gushaoakui@126.com' }
  s.source       = { :git => "https://github.com/shaokui-gu/GM-Dialog.git" }
  s.source_files = 'Sources/*.swift'
  s.swift_versions = ['5.2', '5.3', '5.4']
  s.dependency 'Alamofire'
  s.dependency 'ReachabilitySwift'
  s.requires_arc = true
end
