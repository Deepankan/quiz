task :create_role => [:environment]  do
# Role.create!(:name => "Super Admin")
 
#  #other role
  Role.create!(:name => "admin")
 
 #create a universal permission
 Permission.create!(:subject_class => "all", :action => "manage")
 
 #assign super admin the permission to manage all the models and controllers
 role = Role.find_by_name('admin')
 role.permissions << Permission.first
end