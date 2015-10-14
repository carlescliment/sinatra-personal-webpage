require 'rubygems'
require_relative './app'
require_relative './tasks/index_creator'
desc "Run server"
task :serverup do
    system "shotgun"
end

namespace :blog do

    desc "Reindex posts"
    task :reindex do
        app = PersonalWebPage.new
        blog_path = app.settings.root + '/' + app.settings.blog['source_dir']
        publications_path = app.settings.root + '/' + app.settings.publications['source_dir']
        create_index(blog_path, '/blog')
        create_index(publications_path, '/publications')
    end

    def create_index(path, url)
        creator = IndexCreator.new(path, url)
        creator.create
    end
end
