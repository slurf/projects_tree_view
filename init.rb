require 'redmine'

ActionDispatch::Callbacks.to_prepare do 

  # repeat this structure for all patches
  #require_dependency 'projects_helper'
  require_dependency 'projects_tree_helper'
  ProjectsHelper.send :include, ProjectTreeHelper

end

Redmine::Plugin.register :projects_tree_view do
  name 'Projects Tree View plugin'
  author 'Chris Peterson'
  description 'Will turn the projects page into a tree view'
  version '0.0.9'
end
