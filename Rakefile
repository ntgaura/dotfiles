require 'mkmf'

SRC_DIR = File.dirname(File.expand_path(__FILE__))

module OS
	def self.mac?
		(/darwin/ =~ RUBY_PLATFORM) != nil
	end

	def self.linux?
		not self.mac?
	end

  def self.archlinux?
    File.exist? '/etc/arch-release'
  end
end

# 実行ファイルやファイルが存在するならtrue
def exist?(path)
  return true if find_executable path
  return true if File.exist?(File.expand_path path)
  false
end

class Array
  def without_comments(sep = '#')
    self
      .map(&:chomp)
      .map { |line| line.split(sep, 2).fetch(0, '') }
      .map(&:strip)
      .reject { |line| line.empty? }
  end
end

desc 'Setup all'
task setup: [:'mac:setup', :'linux:setup', :'anyenv:setup', :'rust:install'] do
end

namespace :rust do
  desc 'Install rustup'
  task :install do
    next if exist? '~/.cargo'
    sh 'curl https://sh.rustup.rs -sSf | sh'
  end
end

namespace :anyenv do
	desc 'Setup anyenv and envs, envs-plugins'
	task :setup do
    next if exist? "~/.anyenv"

    sh 'git clone https://github.com/riywo/anyenv ~/.anyenv'
    sh 'mkdir -p ~/.anyenv/envs'
    sh 'mkdir -p $(anyenv root)/plugins'
    sh 'git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update'

    sh 'anyenv install -s rbenv'
    sh 'anyenv install -s pyenv'
    sh 'anyenv install -s ndenv'

    sh "git clone https://github.com/pyenv/pyenv-virtualenv.git $(anyenv root)/envs/pyenv/plugins/pyenv-virtualenv"
	end	

  desc 'Install ruby versions by rbenv'
  task rbenv: [:setup] do
    sh 'rbenv install -s 2.5.1'
    sh 'rbenv global 2.5.1'
    sh 'gem install bundler'
  end

  desc 'Install python versions by pyenv'
  task pyenv: [:setup] do
    sh 'pyenv install -s 2.7.15'
    sh 'pyenv virtualenv 2.7.15 neovim2'
    sh 'pyenv shell neovim2; pip install neovim'

    sh 'pyenv install -s 3.6.5'
    sh 'pyenv virtualenv 3.6.5 neovim3'
    sh 'pyenv shell neovim3; pip install neovim'

    sh 'pyenv global 3.6.5'
  end

  desc 'Install nodejs versions by ndenv'
  task ndenv: [:setup] do
    sh 'ndenv install -s v10.1.0'
    sh 'ndenv global v10.1.0'
  end

  desc 'Install language versions and packages'
  task packages: [:rbenv, :pyenv, :ndenv]
end

namespace :mac do
  desc 'Mac full setup'
	task setup: [:'brew:setup', :'mas:setup']

	namespace :brew do
		desc 'Install brew'	
		task :install do
			next unless OS.mac?
      next if exist? 'brew'

      sh '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
		end

		desc 'Tap brew packages'
		task tap: [:install, 'Brewrepos'] do
			next unless OS.mac?

			repos = File.readlines('Brewrepos').without_comments
			repos.each do |repo|
				sh "brew tap #{repo}"
			end
		end

		desc 'Install brew packages'
		task packages: [:tap, 'Brewfile', 'Caskfile'] do
			next unless OS.mac?

			installed_app = `brew list`.split("\n").map { |app| app.split(' ')[0] }

			packages = File.readlines('Brewfile').without_comments
			packages = packages - installed_app
			packages.each do |package|
				sh "brew install #{package}"
			end

			installed_app = `brew cask list`.split("\n").map { |app| app.split(' ')[0] }
			packages = File.readlines('Caskfile').without_comments
			packages = packages - installed_app
			packages.each do |package|
				sh "brew cask install #{package}"
			end
		end

		desc 'Brew full setup'
		task setup: [:install, :packages]
	end

	namespace :mas do
		desc 'Install mas(=Mac AppStore) command line tool'
		task install: [:'mac:brew:install'] do
			next unless OS.mac?
      next if exist? 'mas'

			sh "brew install mas"
		end

		desc 'Install mas(=Mac AppStore) packages'
		task packages: [:install, 'Masfile'] do
			next unless OS.mac?

			# MasfileからアプリのIDを抽出
			apps = File.readlines('Masfile').without_comments

			# インストール済みのアプリを抽出し、カットする
			installed_app = `mas list`.split("\n").map { |app| app.split(' ')[0] }
			install_app = apps - installed_app

			install_app.map do |app|
				sh "mas install #{app}"
			end
		end

		desc 'MAS(=Mac AppStore) full setup'
		task setup: [:install, :packages]
	end
end

namespace :linux do
  desc 'Linux full setup'
	task setup: [:'yaourt:setup']

	namespace :yaourt do
		desc 'Install yaourt packages'
		task packages: ['Yaourtfile'] do
			next unless OS.archlinux?

			installed_app = `yaourt -Qq`.split("\n").map { |app| app.split(' ')[0] }

			packages = File.readlines('Yaourtfile').without_comments
			packages = packages - installed_app
			packages.each do |package|
				sh "yaourt -S --noconfirm #{package}"
			end
		end

		desc 'Yaourt full setup'
		task setup: [:packages]
	end
end
