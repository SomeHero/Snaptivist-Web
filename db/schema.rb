# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131114180415) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "choice_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "avatar_url"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "call_results", :force => true do |t|
    t.string   "result"
    t.string   "comment"
    t.integer  "phone_campaign_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.boolean  "delivered"
    t.datetime "delivered_at"
  end

  add_index "call_results", ["phone_campaign_id"], :name => "index_call_results_on_phone_campaign_id"

  create_table "choices", :force => true do |t|
    t.string   "choice"
    t.integer  "poll_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "client_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "client_users", ["email"], :name => "index_client_users_on_email", :unique => true
  add_index "client_users", ["reset_password_token"], :name => "index_client_users_on_reset_password_token", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "clients", ["user_id"], :name => "index_clients_on_user_id"

  create_table "external_accounts", :force => true do |t|
    t.string   "type"
    t.string   "external_id"
    t.integer  "user_id"
    t.string   "email"
    t.datetime "authenticated_at"
    t.datetime "allowed_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "external_accounts", ["user_id"], :name => "index_external_accounts_on_user_id"

  create_table "layouts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "mailing_addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "string"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "email_address"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "template_name"
    t.integer  "layout_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "pages", ["layout_id"], :name => "index_pages_on_layout_id"

  create_table "petitions", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.integer  "target_count"
    t.integer  "target_id"
    t.string   "short_url"
    t.string   "rewrite_url_key"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "signatures_count"
    t.integer  "user_id"
    t.string   "header_image_file_name"
    t.string   "header_image_content_type"
    t.integer  "header_image_file_size"
    t.datetime "header_image_updated_at"
    t.string   "subdomain"
    t.string   "comment"
    t.string   "target_headline_text"
    t.string   "call_to_action_button_text"
    t.string   "signature_comment_placeholder_text"
    t.string   "sign_with_facebook_cta_button_text"
    t.string   "sign_with_email_cta_button_text"
    t.string   "default_tweet_text"
    t.string   "action_tags"
    t.string   "tweet_cta_button_text"
    t.boolean  "active",                              :default => false
    t.boolean  "unsponsored",                         :default => false
    t.integer  "client_id"
    t.integer  "layout_id"
    t.integer  "theme_id"
    t.integer  "premium_offer_id"
    t.string   "headline_primary"
    t.string   "headline_secondary"
    t.string   "subheadline"
    t.string   "delivery_headline_primary"
    t.string   "delivery_headline_secondary"
    t.string   "delivery_subheadline"
    t.string   "premium_headline_primary"
    t.string   "premium_headline_secondary"
    t.string   "premium_subheadline"
    t.string   "delivery_call_to_action_text"
    t.string   "delivery_call_to_action_button_text"
    t.string   "delivery_skip_button_text"
    t.string   "delivery_more_tweets_button_text"
    t.string   "premium_call_to_action_text"
    t.string   "premium_call_to_action_button_text"
    t.string   "premium_skip_button_text"
    t.string   "premium_more_tweets_button_text"
    t.string   "signature_more_signers_button_text"
  end

  add_index "petitions", ["target_id"], :name => "index_petitions_on_target_id"

  create_table "phone_campaigns", :force => true do |t|
    t.string   "title"
    t.string   "summary"
    t.integer  "target_count"
    t.string   "short_url"
    t.string   "rewrite_url_key"
    t.integer  "target_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "user_id"
    t.integer  "call_results_count"
    t.string   "subdomain"
    t.string   "header_image_file_name"
    t.string   "header_image_content_type"
    t.integer  "header_image_file_size"
    t.datetime "header_image_updated_at"
    t.string   "comment"
  end

  add_index "phone_campaigns", ["target_id"], :name => "index_phone_campaigns_on_target_id"

  create_table "poll_responses", :force => true do |t|
    t.string   "comment"
    t.integer  "poll_id"
    t.integer  "choice_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "poll_responses", ["choice_id"], :name => "index_poll_responses_on_choice_id"
  add_index "poll_responses", ["poll_id"], :name => "index_poll_responses_on_poll_id"

  create_table "polls", :force => true do |t|
    t.string   "question"
    t.string   "short_url"
    t.string   "rewrite_url_key"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "user_id"
    t.string   "subdomain"
    t.string   "header_image_file_name"
    t.string   "header_image_content_type"
    t.integer  "header_image_file_size"
    t.datetime "header_image_updated_at"
    t.string   "comment"
  end

  create_table "premium_gives", :force => true do |t|
    t.integer  "user_id"
    t.integer  "signature_id"
    t.integer  "mailing_address_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "premium_gives", ["mailing_address_id"], :name => "index_premium_gives_on_mailing_address_id"
  add_index "premium_gives", ["signature_id"], :name => "index_premium_gives_on_signature_id"
  add_index "premium_gives", ["user_id"], :name => "index_premium_gives_on_user_id"

  create_table "premium_offers", :force => true do |t|
    t.string   "name"
    t.string   "headline_text"
    t.string   "call_to_action_button_text"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "signatures", :force => true do |t|
    t.integer  "user_id"
    t.integer  "petition_id"
    t.text     "comment"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "delivered"
    t.datetime "delivered_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.boolean  "opt_in"
    t.string   "zip_code"
    t.boolean  "shared"
    t.datetime "shared_at"
    t.string   "signature_method"
    t.integer  "tweet_id"
  end

  add_index "signatures", ["petition_id"], :name => "index_signatures_on_petition_id"
  add_index "signatures", ["user_id"], :name => "index_signatures_on_user_id"

  create_table "state_informations", :force => true do |t|
    t.string   "state_name"
    t.string   "short_code"
    t.string   "political_hashtag"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "target_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "targets", :force => true do |t|
    t.string   "first_name"
    t.string   "title"
    t.string   "twitter_handle"
    t.string   "email_address"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "nickname"
    t.string   "party"
    t.string   "state"
    t.string   "district"
    t.string   "in_office"
    t.string   "gender"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "webform"
    t.string   "congress_office"
    t.string   "bioguide_id"
    t.string   "votesmart_id"
    t.string   "fec_id"
    t.string   "govtrack_id"
    t.string   "crp_id"
    t.string   "congresspedia_url"
    t.string   "youtube_url"
    t.string   "facebook_id"
    t.string   "official_rss"
    t.string   "senate_class"
    t.string   "birthdate"
    t.integer  "targetgroup_id"
    t.integer  "state_information_id"
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "css_file"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_notification_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "notification_type"
    t.string   "notification_uri"
    t.boolean  "sent"
    t.boolean  "test"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_notification_logs", ["user_id"], :name => "index_user_notification_logs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                            :default => "", :null => false
    t.string   "encrypted_password",               :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zip_code"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "avatar_url"
    t.string   "organization_name"
    t.string   "organization_avatar_file_name"
    t.string   "organization_avatar_content_type"
    t.integer  "organization_avatar_file_size"
    t.datetime "organization_avatar_updated_at"
    t.string   "action_tags"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "views", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "views", ["email"], :name => "index_views_on_email", :unique => true
  add_index "views", ["reset_password_token"], :name => "index_views_on_reset_password_token", :unique => true

end
