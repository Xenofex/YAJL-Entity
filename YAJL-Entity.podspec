Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YAJL-Entity"
  s.version      = "1.0.0"
  s.summary      = "A JSON framework that can deserialize the JSON string into real objects, with 0.1 configuration."

  s.description  = <<-DESC
                   On top of yajl-objc, YAJL-Entity deserialize the JSON string directly into Objective-C objects, as opposed to what you get from most other libraries: NSDictionary or NSData. Which makes your models as clean as possible.
                   DESC

  s.homepage     = "https://github.com/Xenofex/yajl-objc/tree/master/YAJL-Entity"

  s.license      = 'MIT'
  # s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.author       = { "Eli Wang" => "sirxenofex@gmail.com" }

  s.platform     = :ios

  s.source       = { :git => "http://github.com/Xenofex/yajl-objc.git", :tag => "1.0.0", :submodules => true }

  s.source_files  = 'yajl-objc/Classes/**/*.{h,m}', 'yajl-objc/Libraries/**/*.{h,m}', 
                    'yajl-objc/yajl-1.0.11/**/*.{h,c}', 'YAJL-Entity/*.{h,m}'
  s.header_mappings_dir = 'yajl-objc/yajl-1.0.11'
  s.requires_arc = false
  # s.compiler_flags = '-all_load'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-all_load'}
end
