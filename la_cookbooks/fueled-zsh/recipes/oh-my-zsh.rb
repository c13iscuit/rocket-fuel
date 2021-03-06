zsh_home = ::File.join(ENV['HOME'], '.oh-my-zsh')

script "oh-my-zsh install from github" do
  interpreter "bash"
  url = "https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh"
  code <<-EOS
    curl -sLf #{url} -o - | sh
    chsh -s /bin/zsh
  EOS
  not_if { File.directory?(zsh_home) }
end

template File.join(zsh_home, 'custom/.oh-my-zsh.zsh') do
  source 'oh-my-zsh.zsh.erb'
  owner node['current_user']
  action :create_if_missing
  variables({ theme: node['rocket-fuel']['oh-my-zsh']['theme'] })
end

require "chef-sudo"
sudo 'ensure ownership of ohmyzsh home' do
  user 'root'
  command 'chown -R ' + node['current_user'] +':staff "' + zsh_home + '"'
end
