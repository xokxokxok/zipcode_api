module ApplicationHelper
  class ActionView::Helpers::FormBuilder
    # http://stackoverflow.com/a/2625727/1935918
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::FormOptionsHelper
    def enum_select(name, options = {})
      # select_tag "company[time_zone]", options_for_select(Company.time_zones
      #   .map { |value| [value[0].titleize, value[0]] }, selected: company.time_zone)
      select_tag @object_name + "[#{name}]", options_for_select(@object.class.send(name.to_s.pluralize)
                                                                    .map { |value| [value[0].titleize, value[0]] }, selected: @object.send(name))
    end
  end
end