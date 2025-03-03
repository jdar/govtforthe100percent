class StringValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value.is_a?(String)
        record.errors.add(attribute, 'must be a string')
        end
    end
end