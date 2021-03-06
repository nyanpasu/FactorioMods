class ModSerializer < ActiveModel::Serializer
  attributes :id, :url, :categories, :author, :contact

  attribute :name,            key: :title
  attribute :info_json_name,  key: :name
  attribute :summary,         key: :description
  attribute :official_url,    key: :homepage

  has_many :versions, key: :releases
  def versions
    @options[:versions] || object.versions
  end

  def categories
    object.categories.map(&:slug)
  end

  def author
    object.author && object.author.name
  end

  def url
    Rails.application.routes.url_helpers.mod_url(object) # Eww
  end
end
