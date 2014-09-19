class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  	private
	def require_login()
		unless session[:user_id]
			flash[:error] = "Sorry, you must be logged in to perform that action."
			redirect_to(:controller=>"dashboard", :action=>"index")
		end
	end

 	private
	def require_admin()
		unless User.find(session[:user_id]).login == ENV['MASTER_ADMIN_USER']
			flash[:error] = "Sorry, you must be an admin to perform that action."
			redirect_to(:controller=>"dashboard", :action=>"index")
		end
	end

	private

	private
	def allow_iframe
    	response.headers.delete "X-Frame-Options"
  	end

  	protected
	def get_results(className, joins, params)
		if(params[:search]) and eval("#{className}.respond_to?('get_related_to_search')")
			search = params[:search]
			obj_array = eval("#{className}.get_related_to_search('#{search}')")
		else 
			if joins.blank?
				obj_array = eval("#{className}.all")
			else
				obj_array = eval("#{className}.joins(#{joins})")
			end
		end
		if(params[:show_all_years]==false or params[:show_all_years]=='false')
			
			obj_array = obj_array.select {|obj| obj[:year] == Constant.constants[:cur_year] or obj[:year] == Constant.constants[:cur_year].to_s }
		end

		if(params[:sort_by])
			if obj_array.respond_to?('order')
				obj_array = obj_array.order(params[:sort_by])
			else
				#obj_array.sort_by! { |obj| obj[params[:sort_by]] }
				obj_array.sort!{ |a,b| 
					a[params[:sort_by]] && b[params[:sort_by]] ? a[params[:sort_by]] <=> b[params[:sort_by]] : a[params[:sort_by]] ? -1 : 1 
				} 
			end
		end
		return obj_array
	end


end
