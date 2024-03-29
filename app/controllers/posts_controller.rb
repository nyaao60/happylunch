class PostsController < ApplicationController
  before_action :correct_user_post, only: [:edit, :update,:destroy]
  before_action :logged_in_user, only: [:new,:create,:show,:index,:edit,:update,:destroy,:search_keyword]
  before_action :admin_user, only: [:index]
  

  def new
    @post=Post.new
  end

  def create
    @post=current_user.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(',')
    if @post.save
      @post.save_tags(tag_list)
      flash[:success]="投稿しました！"
      redirect_to post_path(@post)
    else
      flash.now[:alert]="入力に誤りがあります"
      render 'new'
    end
  end 

  def show
    @post=Post.find(params[:id])
    @posts=Post.includes(:likes)
    @user=User.find_by(id:@post.user_id)
    @comment=@post.comments.new
    @comments = @post.comments.includes(:user)
    @likes=@post.likes.includes(:user)
    @post_tags = @post.tags
  end
  
  def index
    @posts = Post.includes(:user,:likes,:comments,:tags).order(created_at: :desc).page(params[:page])
  end

  def edit
    @post=Post.find(params[:id])
    @tags = @post.tags.pluck(:tag_name).join(',')
  end  

  def update
    @post=Post.find(params[:id])      
    tag_list = params[:post][:tag_name].split(',')
    if @post.update(post_params)
      @post.update_tags(tag_list)
      flash[:success]="投稿を更新しました！"
      redirect_to post_path(@post)
    else
      render 'edit'
    end 
  end

  def destroy
    @post=Post.find(params[:id])
    if @post.destroy
      flash[:success]="投稿を削除しました！" 
      redirect_to root_url
    end
  end
  
  def tags
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all.includes(:user,:tags,:likes,:comments,:tags).order(created_at: :desc)
  end

  def search
    results=Geocoder.search(params[:location])
    # Geocoder.searchで引数を基にした結果で、緯度経度、住所情報などが含まれる。
    if results.empty?
      flash[:alert]="入力された住所の情報がありません"
      redirect_to root_path      
    else
      selection = params[:keyword]
      latitude = results.first.coordinates[0]
      longtitude = results.first.coordinates[1]
      #distance = 0.621371 マイルを約1キロ換算
      
      posts = Post.includes(:user,:likes,:comments,:tags).within_box(75,latitude,longtitude)
      # 投稿が増えれば、入力された場所情報の2km範囲内のpostの配列をpostsに入れたいが、現状、投稿数が少ないため、hit件数を1件でも多く表示したいため、一時的に梅田駅〜京都駅間の45km範囲内にしている。
      case selection
      when 'near' 
        @posts =Post.includes(:user,:likes,:comments,:tags).near(results.first.coordinates).page(params[:page])
      when 'inexpensive'
        @posts= posts.order(price: :asc, created_at: :desc).page(params[:page])
      when 'rating'
        @posts= posts.order(five_star_rating: :desc, created_at: :desc).page(params[:page])
      when 'vagetable'
        @posts= Post.joins(:tags).where(tags: { tag_name: "野菜豊富" }).near(results.first.coordinates).page(params[:page])
      else
        @posts=posts.order(created_at: :desc).page(params[:page])
      end
    end
  end   

  def search_keyword
    @posts = Post.search(params[:keywords]).order(created_at: :desc).page(params[:page]).per(8)    
  end

  private

  def post_params
    params.require(:post).permit(:store_name,:lunch_name,:address, :latitude, :longitude, {post_images:[]},:price,:five_star_rating,:lots_of_vegetables,:body)
  end

  def correct_user_post 
    @post=Post.find(params[:id])
    if User.find_by(id:@post.user_id) != current_user && current_user.admin == false
    redirect_to user_path(current_user),alert: '他のユーザーの投稿の編集や削除はできません。'  
    end
  end 

end