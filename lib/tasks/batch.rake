namespace :batch do
  desc "create appropriate hierarchy and import files from the specified CSV"
  task :import, [:path, :override] => :environment do |t, args|
    args.with_defaults(:override => true)
    # require 'csv'
    filePath = args.path
    overrideExistingFiles = args.override
    puts "Reading from the file: #{filePath}\n"    
    puts "I will override existing files: #{overrideExistingFiles}"
    DataTrack.import(filePath, overrideExistingFiles)    
  end

end
