
Pod::Spec.new do |s|
  s.name             = 'BucketList'
  s.version          = '0.1.2'
  s.summary          = 'Memory and Disk Caching with Encryption options'

  s.description  = <<-DESC
    Need caching? Focused on security? BucketList makes working with encrypted caching easy. Also supports stand your standard key value caching as well.
  DESC

  s.homepage         = 'https://github.com/benbahrenburg/BucketList'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Ben Bahrenburg' => 'hello@bencoding.com' }
  s.source           = { :git => 'https://github.com/benbahrenburg/BucketList.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bencoding'

  s.ios.deployment_target = '10.0'
  s.source_files = 'BucketList/Classes/**/*'
  s.dependency 'RNCryptor', '~> 5.0'

end
