namespace :radiant do
  namespace :extensions do
    namespace :bracket_ext do
      
      desc "Runs the migration of the Bracket Ext extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          BracketExtExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          BracketExtExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end
      
      desc "Copies public assets of the Bracket Ext to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from BracketExtExtension"
        Dir[BracketExtExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(BracketExtExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless BracketExtExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from BracketExtExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join BracketExtExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end  
      
      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = BracketExtExtension.root + "/config/locales"
        words = TranslationSupport.get_translation_keys(language_root)
        
        Dir["#{language_root}/*.yml"].each do |filename|
          next if filename.match('_available_tags')
          basename = File.basename(filename, '.yml')
          puts "Syncing #{basename}"
          (comments, other) = TranslationSupport.read_file(filename, basename)
          words.each { |k,v| other[k] ||= words[k] }  # Initializing hash variable as empty if it does not exist
          other.delete_if { |k,v| !words[k] }         # Remove if not defined in en.yml
          TranslationSupport.write_file(filename, basename, comments, other)
        end
      end
    end
  end
end
