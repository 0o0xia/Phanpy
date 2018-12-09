platform :ios, '12.0'

target 'Phanpy' do
  use_frameworks!

  pod 'DateToolsSwift', '~> 4.0'
  pod 'Kanna', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'MastodonKit', '~> 2.0'
  pod 'SwiftLint'

  script_phase :name => 'SwiftLint', :script => '${PODS_ROOT}/SwiftLint/swiftlint'

  target 'PhanpyTests' do
    inherit! :search_paths
  end
end
