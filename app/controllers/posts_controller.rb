class PostsController < ApplicationController
  
  def new
    @post=Post.new
  end

  def create
    @post=current_user.posts.build(post_params)
    if @post.save
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
  end
  
  def edit
    @post=Post.find(params[:id])
  end  

  def update
    @post=Post.find(params[:id])      
    if @post.update(post_params)
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
      posts = Post.within_box(20,latitude,longtitude)
      # 入力された場所情報の1km範囲内のpostの配列をpostsに入れている。
      case selection
      when 'near' 
        @posts=Post.near(results.first.coordinates,20).page(params[:page])
      else
        @posts=posts
      end
    end
  end   

    private

    def post_params
      params.require(:post).permit(:store_name,:address, :latitude, :longitude, {post_images:[]},:price,:five_star_rating,:lots_of_vegetables,:body)
    end
end