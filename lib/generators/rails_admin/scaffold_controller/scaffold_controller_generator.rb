class RailsAdmin::ScaffoldControllerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  
  source_root File.expand_path('../templates', __FILE__)
  check_class_collision :suffix => "Helper"
  check_class_collision :suffix => "Controller"

  class_option :orm, :banner => "NAME", :type => :string, :required => true, :desc => "ORM to generate the controller for"

  def create_controller_files
    template 'controller.rb', File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
    template 'helper.rb', File.join('app/helpers/admin', class_path, "#{controller_file_name}_helper.rb")
  end

  def create_root_folder
    empty_directory File.join("app/views/admin", controller_file_path)
  end

  def copy_view_files
    available_views.each do |view|
      filename =  [ view, :html, :erb ].compact.join(".")
      template(filename, File.join("app/views/admin", controller_file_path, filename))
    end
  end

  def add_resource_route
    route_config =  "namespace :admin do "
    route_config << "resources :#{file_name.pluralize}"
    route_config << " end"
    route route_config
  end

  protected

  # test on 'id' and not primary beacause not always the same thing
  def columns_without_id
    singular_table_name.classify.constantize.columns.select{ |c| c.name != 'id' }
  end

  def available_views
    #%w(index edit show new _form)
    %w(index)
  end

end
