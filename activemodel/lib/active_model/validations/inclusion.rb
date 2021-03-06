require "active_model/validations/clusivity"

module ActiveModel

  # == Active Model Inclusion Validator
  module Validations
    class InclusionValidator < EachValidator #:nodoc:
      include Clusivity

      def validate_each(record, attribute, value)
        unless include?(record, value)
          record.errors.add(attribute, :inclusion, options.except(:in, :within).merge!(:value => value))
        end
      end
    end

    module HelperMethods
      # Validates whether the value of the specified attribute is available in a
      # particular enumerable object.
      #
      #   class Person < ActiveRecord::Base
      #     validates_inclusion_of :gender, in: %w( m f )
      #     validates_inclusion_of :age, in: 0..99
      #     validates_inclusion_of :format, in: %w( jpg gif png ), message: "extension %{value} is not included in the list"
      #     validates_inclusion_of :states, in: ->(person) { STATES[person.country] }
      #   end
      #
      # Configuration options:
      # * <tt>:in</tt> - An enumerable object of available items. This can be
      #   supplied as a proc or lambda which returns an enumerable. If the
      #   enumerable is a range the test is performed with <tt>Range#cover?</tt>,
      #   otherwise with <tt>include?</tt>.
      # * <tt>:within</tt> - A synonym(or alias) for <tt>:in</tt>
      # * <tt>:message</tt> - Specifies a custom error message (default is: "is
      #   not included in the list").
      # * <tt>:allow_nil</tt> - If set to +true+, skips this validation if the
      #   attribute is +nil+ (default is +false+).
      # * <tt>:allow_blank</tt> - If set to +true+, skips this validation if the
      #   attribute is blank (default is +false+).
      #
      # There is also a list of default options supported by every validator:
      # +:if+, +:unless+, +:on+ and +:strict+.
      # See <tt>ActiveModel::Validation#validates</tt> for more information
      def validates_inclusion_of(*attr_names)
        validates_with InclusionValidator, _merge_attributes(attr_names)
      end
    end
  end
end
