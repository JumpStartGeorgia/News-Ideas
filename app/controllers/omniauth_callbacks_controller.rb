class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		user = User.from_omniauth(request.env["omniauth.auth"])
		if user.persisted?
			flash.notice = 'signed in!'
			sign_in_and_redirect user
		else
			session["devise.user_attributes"] = user.attributes
			redirect_to new_user_registration_url
		end
	end
end
