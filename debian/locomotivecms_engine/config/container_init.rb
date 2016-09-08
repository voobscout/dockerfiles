%w(rubygems yaml).each(&:require)

@fname = "#{ENV['HOME']}/engine/config/mongoid.yml"
@mongoid_yml = YAML.load_file @fname

def chk_set_env
  required_env = %w(MONGODB_HOST MONGODB_USER MONGODB_DATABASE MONGODB_PASS)
  required_env.each do |var|
    raise ArgumentError, "#{var} - Undefined!" unless ENV[var]
  end
  prod = @mongoid_yml['production']['clients']['default']
  prod['database'] = ENV['MONGODB_DATABASE']
  prod['hosts'] = [ENV['MONGODB_HOST']]
  prod['options'] = {'max_pool_size' => 1}
  IO.write(@fname, YAML.dump(@mongoid_yml))
end
