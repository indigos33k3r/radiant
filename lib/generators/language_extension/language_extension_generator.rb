class LanguageExtensionGenerator < Rails::Generator::NamedBase
  default_options :with_test_unit => false
  
  attr_reader :extension_path, :extension_file_name, :localization_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @extension_file_name = "i18n_#{file_name}_extension"
    @extension_path = "vendor/extensions/i18n_#{file_name}"
    @localization_name = localization_name
  end
  
  def manifest
    record do |m|
      m.directory "#{extension_path}/config/locales"
      m.directory "#{extension_path}/lib/tasks"
      
      m.template 'README',                "#{extension_path}/README"
      m.template 'extension.rb',          "#{extension_path}/#{extension_file_name}.rb"
      m.template 'tasks.rake',            "#{extension_path}/lib/tasks/#{extension_file_name}_tasks.rake"
      m.template 'lang.yml',              "#{extension_path}/config/locales/#{localization_name}.yml"
      
      if options[:with_test_unit]
        m.directory "#{extension_path}/test/fixtures"
        m.directory "#{extension_path}/test/functional"
        m.directory "#{extension_path}/test/unit"

        m.template 'Rakefile',            "#{extension_path}/Rakefile"
        m.template 'test_helper.rb',      "#{extension_path}/test/test_helper.rb"
        m.template 'functional_test.rb',  "#{extension_path}/test/functional/#{extension_file_name}_test.rb"
      else
        m.directory "#{extension_path}/spec/controllers"
        m.directory "#{extension_path}/spec/models"        
        m.directory "#{extension_path}/spec/views"
        m.directory "#{extension_path}/spec/helpers"
        m.directory "#{extension_path}/features/support"
        m.directory "#{extension_path}/features/step_definitions/admin"

        m.template 'RSpecRakefile',       "#{extension_path}/Rakefile"
        m.template 'spec_helper.rb',      "#{extension_path}/spec/spec_helper.rb"
        m.file     'spec.opts',           "#{extension_path}/spec/spec.opts"
        m.file     'cucumber.yml',        "#{extension_path}/cucumber.yml"
        m.template 'cucumber_env.rb',     "#{extension_path}/features/support/env.rb"
        m.template 'cucumber_paths.rb',   "#{extension_path}/features/support/paths.rb"
      end
    end
  end
  
  def class_name
    'I18n' + super.to_name.gsub(' ', '') + 'Extension'
  end
  
  def extension_name
    class_name.to_name('Extension')
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--with-test-unit", 
           "Use Test::Unit for this extension instead of RSpec") { |v| options[:with_test_unit] = v }
  end
  
  def localization_name
    file_name.split('_')[1] ? "#{file_name.split('_')[0]}-#{file_name.split('_')[1].upcase}" : file_name 
  end
end