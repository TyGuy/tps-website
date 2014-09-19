#TODO: Should we change this to module? Probably works either way. We do need to store information though (login, email, pw)

class User < ActiveRecord::Base

	def first_name()
		user = self.retrieve_user
		return user.first_name
	end

	def name()
		user = self.retrieve_user
		return (user.nil?) ? nil : user.name
	end

	def email()
		user = self.retrieve_user
		return (user.nil?) ? nil : user.email
	end
		
	def retrieve_user()
		user = CoreMember.find(self.id)
		if user.blank?
			user = Mentor.find(self.id)
			if user.blank?
				user = Mentee.find(self.id)
			end
		end
		return user
	end

	def change_password(new_pw)
		self.password = new_pw
		return self.save
	end

	def is_core_member(year=nil)
		return (not CoreMember.find(self.id).blank?)
	end

	def is_mentor(year=nil)
		return (not Mentor.find(self.id).blank?)
	end

	def is_mentee(year=nil)
		return (not Mentee.find(self.id).blank?)
	end

	def get_core_member(year=nil)
		#if no year specified, make year the current year
		if year==nil
			year = Constant.constants[:cur_year]
		end
		cm = CoreMember.find_by(id: self.id, year: year)
		#if can't find member (for example if from a past year, and the ids are different)
		if cm.blank?
			new_cm = CoreMember.find_by(id: self.id, year: Constant.constants[:cur_year])
			if new_cm.blank?
				return nil
			end
			return CoreMember.get_by_name_and_year(new_cm.first_name,new_cm.last_name,year)
		end
		return cm
	end

	def get_mentor(year=nil)
		if year==nil
			year = Constant.constants[:cur_year]
		end
		return Mentor.find_by(id: self.id, year: year)
	end

	def get_mentee(year=nil)
		if year==nil
			year = Constant.constants[:cur_year]
		end
		return Mentee.find_by(id: self.id, year: year)
	end

	def validate_password()
		if self.password.length < 8
			errors.add(:password, "must be at least 8 characters.")
		end
	end

	#object must have methods id and first_name and last_name
	def self.create_if_new(object)
		if not User.exists?(object.id)
			names = [object.first_name, object.last_name]
			user = User.new(
				:id => object.id,
				:login => names.join("").downcase,
				:password => "phoenix1",
				:permissions => object.class.name.split('::').last
				)
			if user.save
				return user.id
			else 
				return nil
			end
		end
		return nil
	end

	validate :validate_password


end
