%w(rubygems yaml).each { |r| require r }

@fname = "#{ENV['HOME']}/engine/config/mongoid.yml"
@mongoid_yml = YAML.load_file @fname

def chk_set_env
  required_env = %w(MONGODB_HOST MONGODB_USER MONGODB_DATABASE MONGODB_PASS)
  required_env.each do |var|
    raise ArgumentError, "#{var} - Undefined!" unless ENV[var]
  end

  prod = @mongoid_yml['production']['clients']['default']
  prod['hosts'] = [ENV['MONGODB_HOST'] + ':27017']
  prod['database'] = ENV['MONGODB_DATABASE']
  prod['user'] = ENV['MONGODB_USER']
  prod['password'] = ENV['MONGODB_PASS']
  prod['roles'] = ['root']
  prod['options'] = {'max_pool_size' => 1}

  yaml_string = YAML.dump(@mongoid_yml)
  IO.write(@fname, yaml_string)
end

chk_set_env
