Pod::Spec.new do |s|
  s.name           = 'InnjiaPay'
  s.version         = '0.0.1'
  s.summary        = 'An easy way to pay'
  s.homepage       = 'https://github.com/onexf/InnjiaPay'
  s.license        = 'MIT'
  s.platform       = :ios
  s.author         = {'onexf' => '630850673@qq.com'}
  s.ios.deployment_target = '8.0'
  s.source         = {:git => 'https://github.com/onexf/InnjiaPay.git', :tag => '0.0.1'}
  s.source_files   = 'InnjiaPaySDK.{h,m}'
  s.frameworks     = 'UIKit'
end
