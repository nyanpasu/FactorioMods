class ModVersion < ActiveRecord::Base
  belongs_to :mod, inverse_of: :versions

  has_many :files, class_name: 'ModFile'
  has_many :mod_game_versions, dependent: :destroy
  has_many :game_versions, -> { sort_by_older_to_newer },
           through: :mod_game_versions,
           dependent: :destroy # This actually destroys :mod_game_versions when removing the association.
                               # See https://github.com/rails/rails/issues/7618

  scope :sort_by_older_to_newer, -> { order('sort_order asc') }
  scope :sort_by_newer_to_older, -> { order('sort_order desc') }
  # scope :sort_by_release_date, -> { order('released_at desc') }
  scope :most_recent, -> { order('released_at desc') }

  accepts_nested_attributes_for :files, allow_destroy: true

  # def build
  #   result = super
  #   this.files.build
  #   result
  # end

  ### Validations
  #################

  validates :number, presence: true,
                     length: { maximum: 20 },
                     format: { with: /\A[a-z0-9\-_.]+\Z/ }
  validates :mod, presence: true

  # validates #game_versions to be consecutive
  validate do
    if game_versions.size > 1
      all_game_versions = GameVersion.sort_by_older_to_newer
      start = all_game_versions.find_index game_versions.first

      if all_game_versions[start, game_versions.size] != game_versions
        errors[:game_versions].push 'should be consecutive'
      end
    end
  end

  # validates #released_at not in the future
  validate do
    if released_at.present? # allows blank
      if released_at > 1.hour.since
        errors[:released_at].push I18n.t('activerecord.errors.models.mod_version.attributes.released_at.in_the_future')
      end
    end
  end

  ### Callbacks
  #################

  after_save do
    if not mod.last_release_date or (released_at > mod.last_release_date)
      mod.last_version = self
      mod.last_release_date = released_at
      mod.update_attributes(last_version: self, last_release_date: released_at)
    end
  end

  ### Attributes
  #################

  def game_versions_string
    read_attribute(:game_versions_string) || set_game_versions_string
  end

  def to_label
    number
  end

  def has_files?
    files.size > 0
  end

  private

  def set_game_versions_string
    return if new_record?
    gvs = begin
      last_game_version = game_versions.last
      first_game_version = game_versions.first
      if not last_game_version and not first_game_version
        ''
      elsif last_game_version == first_game_version
        first_game_version.number
      else
        "#{first_game_version.number}-#{last_game_version.number}"
      end
    end

    update_column :game_versions_string, gvs
    self.game_versions_string = gvs
  end
end
