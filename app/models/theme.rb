class Theme < ActiveRecord::Base
  belongs_to :created_by
  belongs_to :updated_by
  attr_accessible :name

  THEMES = %w[classic modern]

  THEMES.each do |theme|
    define_singleton_method theme.to_sym do
      for_name theme
    end
  end

  def self.for_name(theme_name)
    raise ArgumentError.new(':theme_name can not be nil or empty') unless theme_name.present?
    where(name: theme_name.to_s).first
  end

  def as_json(options_for_json={})
    {
        name: name
    }
  end

end
