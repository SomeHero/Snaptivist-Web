class AddBunchOfColumnsToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :middle_name, :string
    add_column :targets, :last_name, :string
    add_column :targets, :name_suffix, :string
    add_column :targets, :nickname, :string
    add_column :targets, :party, :string
    add_column :targets, :state, :string
    add_column :targets, :district, :string
    add_column :targets, :in_office, :string
    add_column :targets, :gender, :string
    add_column :targets, :phone, :string
    add_column :targets, :fax, :string
    add_column :targets, :website, :string
    add_column :targets, :webform, :string
    add_column :targets, :congress_office, :string
    add_column :targets, :bioguide_id, :string
    add_column :targets, :votesmart_id, :string
    add_column :targets, :fec_id, :string
    add_column :targets, :govtrack_id, :string
    add_column :targets, :crp_id, :string
    add_column :targets, :congresspedia_url, :string
    add_column :targets, :youtube_url, :string
    add_column :targets, :facebook_id, :string
    add_column :targets, :official_rss, :string
    add_column :targets, :senate_class, :string
    add_column :targets, :birthdate, :string
  end
end
