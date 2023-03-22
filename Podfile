source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'Boardnote' do
    #pod 'PDFNet', podspec: 'https://www.pdftron.com/downloads/ios/cocoapods/pdfnet/latest.podspec'
    pod 'PDFNet', podspec: 'https://www.pdftron.com/downloads/ios/cocoapods/pdfnet/6.8.6.66869.podspec'

    ## ---- Utility ------
    pod 'JWTDecode'
    pod 'Alamofire', '<= 4.9.1'
    pod 'Cache', '<= 5.2.0'
    pod 'Kingfisher', '<= 5.14.0'
    pod 'Siesta'
    pod 'Siesta/UI'
    
    ## ---- Controls ------
    pod 'JTAppleCalendar', '<= 7.1.8'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end
