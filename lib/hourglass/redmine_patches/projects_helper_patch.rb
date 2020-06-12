require_dependency 'queries_helper'

module Hourglass
  module RedminePatches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method :project_settings_tabs_without_hourglass, :project_settings_tabs
          alias_method :project_settings_tabs, :project_settings_tabs_with_hourglass
        end
      end

      module InstanceMethods
        def project_settings_tabs_with_hourglass
          @settings = Hourglass::ProjectSettings.load(@project)

          tabs = project_settings_tabs_without_hourglass
          tabs.push(:name => Hourglass::PLUGIN_NAME.to_s,
                    :partial => 'hourglass_projects/hourglass_settings',
                    :label => 'hourglass.project_settings.title') if @project.module_enabled?(Hourglass::PLUGIN_NAME) &&
                      User.current.allowed_to?(:select_project_modules, @project)
          tabs
        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include?(Hourglass::RedminePatches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, Hourglass::RedminePatches::ProjectsHelperPatch)
end
