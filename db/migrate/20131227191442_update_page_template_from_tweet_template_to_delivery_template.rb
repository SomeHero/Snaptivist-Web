class UpdatePageTemplateFromTweetTemplateToDeliveryTemplate < ActiveRecord::Migration
  def up
  	pages = Page.where(:template_name => "tweet_template")

  	pages.each do |page| 
  		page.template_name = "delivery_template"

  		page.save!
  	end
  end

  def down
  end
end
