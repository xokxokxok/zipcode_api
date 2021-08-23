# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.include?('<label for')
    html_tag.gsub!('<label for', '<label class="with_errors" for').html_safe
  else
    html_tag.html_safe
  end
end