module Slug
  extend ActiveSupport::Concern

  included do
  end

  def create_slug
    slug = self.title.downcase.gsub(/\&/, 'and') # & -> and
    slug.gsub!(/[^a-zA-Z0-9 _]/, "") # remove all bad characters
    slug.gsub!(/\ /, "_") # replace spaces with underscores
    slug.gsub!(/_+/, "_") # replace repeating underscores

    dups = self.class.name.constantize.where(:slug => slug)
    if dups.count == 1 and dups.first != self
      slug = "#{slug}_#{self.id}"
    end
    slug
  end

  def make_slug_unique(slug)
    dups = self.class.name.constantize.where(:slug => slug)
    if dups.count == 1 and dups.first != self
      slug = "#{slug}_#{self.id}"
    end
    slug
  end

  def to_param
    slug
  end

end
