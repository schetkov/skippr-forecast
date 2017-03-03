module Attachments
  class CloudinaryAttributeBuilder
    def initialize(parameters)
      @parameters = parameters
    end

    def call
      active_params.inject([]) do |result, element|
        preloaded = Cloudinary::PreloadedFile.new(element.last)
        raise "Invalid upload signature" unless preloaded.valid?
        result << {
          file_id: preloaded.identifier,
          file_name: preloaded.public_id,
          file_type: element.first.to_s
        }
      end
    end

    private

    attr_reader :parameters

    def file_types
      Attachment.file_types.keys
    end

    def active_params
      parameters.select do |key, values|
        file_types.include?(key) && !!values
      end
    end
  end
end
