# namespace 'permissions' do
  desc "Loading all models and their related controller methods inpermissions table."
  task(:permissions => :environment) do
    arr = []
    #load all the controllers
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        #check if the controller is valid
        arr << entry.camelize.gsub('.rb', '').constantize
      elsif entry =~ /^[a-z]*$/ #namescoped controllers
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/
            arr << "#{entry.titleize}::#{x.camelize.gsub('.rb', '')}".constantize
          end
        end
      end
    end
 
    arr.each do |controller|
      #only that controller which represents a model
      if controller.permission
        #create a universal permission for that model. eg "manage User" will allow all actions on User model.
        write_permission(controller.permission, "manage", 'manage') #add permission to do CRUD for every model.
        controller.action_methods.each do |method|
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
            name, cancan_action = eval_cancan_action(method)
            write_permission(controller.permission, cancan_action, name)
          end
        end
      end
    end
  end

 
#this method returns the cancan action for the action passed.
def eval_cancan_action(action)
  case action.to_s
  when "index"
    name = 'list'
    cancan_action = "index"
    action_desc = I18n.t :index
  when "show"
    name = 'show'
    cancan_action = "show"
    action_desc = I18n.t :show
  when "new"
    name = 'new'
    cancan_action = "new"
    action_desc = I18n.t :new
  when "create"
    #name = 'create and update'
    name = 'create'
    cancan_action = "create"
    action_desc = I18n.t :create
  when "update"
    #name = 'create and update'
    name = 'update'
    cancan_action = "update"
    action_desc = I18n.t :update
  when "edit"
    #name = 'create and update'
    name = 'edit'
    cancan_action = "edit"
    action_desc = I18n.t :edit
  when "delete", "destroy"
    name = 'delete'
    cancan_action = "destroy"
    action_desc = I18n.t :destroy
  else
    name = action.to_s
    cancan_action = action.to_s
    action_desc = "Other: " << cancan_action
  end
  return name, cancan_action
end
 
#check if the permission is present else add a new one.

def write_permission(modell, cancan_action, name)
  #permission  = Permission.find(:first, :conditions => ["subject_class = ? and action = ?", modell, cancan_action])
  permission = Permission.where("subject_class = ? and action = ?", modell, cancan_action).first
  unless permission
    permission = Permission.new
    permission.name = name
    permission.subject_class =  modell
    permission.action = cancan_action
    # permission.status = STATUS_CONFIREMD
    permission.save
  end
end