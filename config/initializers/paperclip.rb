# #created file in appropriate way and this issue isn't relevant any more
# #terrible workaround for the issue with paperclip always thinking tempfiles without extensions are spoofed - ongoing mar 2014
# require 'paperclip/media_type_spoof_detector'
# module Paperclip
#  class MediaTypeSpoofDetector
#    def spoofed?
#      false
#    end
#  end
# end
Paperclip.options[:content_type_mappings] = {
  :json => "text/plain",
  :c3d => "application/octet-stream",
  :bvh => "text/plain"
}