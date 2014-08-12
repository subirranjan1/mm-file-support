namespace :batch do
  desc "create appropriate hierarchy and import files from the specified CSV"
  task :import, [:path] => :environment do |t, args|
    require 'csv'
    filePath = args.path
    puts "Reading from the file: #{filePath}\n"    
    DataTrack.import(filePath)    
  end

end
