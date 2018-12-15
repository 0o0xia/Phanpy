platform :ios, '12.0'

target 'Phanpy' do
  use_frameworks!

  pod 'DateToolsSwift', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'MastodonKit', :git => 'https://github.com/MastodonKit/MastodonKit', :commit => '965a6559b2add8b92dabce907d9c8bd09728a1d1'
  pod 'SwiftLint'

  script_phase :name => 'SwiftLint', :script => '${PODS_ROOT}/SwiftLint/swiftlint'

  target 'PhanpyTests' do
    inherit! :search_paths
  end
end
