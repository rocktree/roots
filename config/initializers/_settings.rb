# loads config/settings.yml file into SETTING constant
config_file = File.join(Rails.root,'config','settings.yml')
raise "#{config_file} is missing!" unless File.exists? config_file
SETTINGS = YAML.load_file(config_file)[Rails.env]
