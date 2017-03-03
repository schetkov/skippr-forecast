module Attachments
  class AttachmentCreator
    def initialize(file_attributes:, resource:)
      @file_attributes = file_attributes
      @resource = resource
    end

    def call
      file_attributes.each do |attrs|
        if resource.persisted?
          resource.attachments.create(attrs)
        else
          resource.attachments.new(attrs)
        end
      end
    end

    private

    attr_reader :file_attributes, :resource
  end
end
