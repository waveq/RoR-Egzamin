class Gist < ActiveRecord::Base
	def self.search(search)
    if search
      find(:all, :conditions => ['lang LIKE ?', "%#{search}%"])
    else
      limit(0)
    end
  end
end
