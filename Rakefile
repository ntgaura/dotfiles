require 'mkmf'

SRC_DIR = File.dirname(File.expand_path(__FILE__))

module OS
	def self.mac?
		(/darwin/ =~ RUBY_PLATFORM) != nil
	end

	def self.linux?
		not self.mac?
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
	desc 'Install anyenv'
	task :install do
    next if exist? "~/.anyenv"

    sh 'git clone https://github.com/riywo/anyenv ~/.anyenv'
    sh 'mkdir -p ~/.anyenv/envs'
	end	

  desc 'Install rbenv'
  task rbenv: [:install] do
    sh 'anyenv install -s rbenv'
    sh 'rbenv install -s 2.5.0'
    sh 'rbenv global 2.5.0'
    sh 'gem install bundler'
  end

  desc 'Install pyenv'
  task pyenv: [:install] do
    sh 'anyenv install -s pyenv'
    sh 'pyenv install -s 2.7.14'
    sh 'pyenv install -s 3.6.4'
    sh 'pyenv global 3.6.4'
  end

  desc 'Install ndenv'
  task ndenv: [:install] do
    sh 'anyenv install -s ndenv'
    sh 'ndenv install -s v9.8.0'
    sh 'ndenv global v9.8.0'
  end

  desc 'Anyenv full setup'
  task setup: [:install, :rbenv, :pyenv, :ndenv]
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
	task setup: []
end
