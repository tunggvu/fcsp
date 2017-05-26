# This migration comes from acts_as_taggable_on_engine (originally 3)
class AddTaggingsCounterCacheToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :taggings_count, :integer, default: 0

    say_with_time "Reset tag column information" do
      ActsAsTaggableOn::Tag.reset_column_information
      say "Tag was reset"
    end

    say_with_time "Reset counters for tags" do
      ActsAsTaggableOn::Tag.find_each do |tag|
        ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
        say "tag-#{tag.id} was reset"
      end
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
