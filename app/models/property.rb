# -*- encoding : utf-8 -*-

class Property < ActiveRecord::Base
  IMAGE_ATTRS = {
      'designation'=>:designation,
      'epoch'=>:epoch,
      'number'=>:number,
      'name'=>:name,
      'argument_of_perihelion'=>:peri,
      'mean_anomaly'=>:m,
      'ascending_node'=>:node,
      'inclination'=>:incl,
      'eccentricity'=>:e,
      'semimajor_axis'=>:a
  }.freeze

  def self.designation(desgn)
    where(designation: desgn).first
  end

  def image_properties
    attributes.slice(*IMAGE_ATTRS.keys).inject({}) do |map, (key, value)|
      map[IMAGE_ATTRS[key]] = value
      map
    end
  end
end
