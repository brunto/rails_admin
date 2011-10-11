<% module_namespacing do -%>
class Admin::<%= controller_class_name %>Controller < RailsAdmin::ApplicationController
  layout "rails_admin/main"
  helper RailsAdmin::ActivoHelper
  
  before_filter :set_param_model
  before_filter :get_model, :except => [:index]
  before_filter :get_object, :only => [:show, :edit, :update, :delete, :destroy]
  before_filter :get_attributes, :only => [:create, :update]
  before_filter :check_for_cancel, :only => [:create, :update, :destroy, :export, :bulk_destroy]

  def index
    @page_type = '<%= plural_name %>'
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @page_type = '<%= plural_name %>'
    @object = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @page_type = '<%= plural_name %>'
    @object = <%= orm_class.build(class_name) %>
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @page_type = '<%= plural_name %>'
    @object = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  def create
    @page_type = '<%= plural_name %>'
    @object = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
    
    respond_to do |format|
      if @object.save
        format.html { redirect_to_on_success }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @page_type = '<%= plural_name %>'
    @object = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      if @object.update_attributes(params[:<%= singular_table_name %>])
        format.html { redirect_to_on_success }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @object = <%= orm_class.find(class_name, "params[:id]") %>
    if @object.destroy
      flash[:notice] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.deleted"))
    else
      flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.deleted"))
    end

    redirect_to list_path(:model_name => '<%= plural_name %>')
  end

  private

  def set_param_model
    params[:model_name] = '<%= plural_name %>'
  end
  
  def get_attributes
    @attributes = params[@abstract_model.to_param.singularize.gsub('~','_')] || {}
    @attributes.each do |key, value|
      # Deserialize the attribute if attribute is serialized
      if @abstract_model.model.serialized_attributes.keys.include?(key) and value.is_a? String
        @attributes[key] = YAML::load(value)
      end
      # Delete fields that are blank
      @attributes[key] = nil if value.blank?
    end
  end

  def redirect_to_on_success
    notice = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.#{params[:action]}d"))
    if params[:_add_another]
      redirect_to new_path(:model_name =>'<%= plural_name %>'), :notice => notice
    elsif params[:_add_edit]
      redirect_to edit_path(:model_name =>'<%= plural_name %>', :id => @object.id), :notice => notice
    else
      redirect_to list_path(:model_name =>'<%= plural_name %>'), :notice => notice
    end
  end

  def check_for_cancel
    redirect_to list_path(:model_name =>'<%= plural_name %>'), :notice => t("admin.flash.noaction") if params[:_continue]
  end
  
end
<% end -%>
