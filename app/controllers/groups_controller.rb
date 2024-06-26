class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  
  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end
  
   def join #6/6join追記！
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  groups_path
   end
  
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
        #6/6追記@group.users << current_user
    @group.users << current_user
    #ここまで
    if @group.save
      redirect_to groups_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  #6/6ここから課題8のための
  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
#current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to groups_path
  end
#6/6ここまで追記

#6/8ここからメール送信機能追記
def new_mail
  @group = Group.find(params[:group_id])
end

def send_mail
  @group = Group.find(params[:group_id])
  group_users = @group.users
  @mail_title = params[:mail_title]
  @mail_content = params[:mail_content]
  ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
end
#6/8ここまでメール送信機能追記
  private

  def group_params
    params.require(:group).permit(:group_name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end