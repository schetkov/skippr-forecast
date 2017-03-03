module CloudinaryHelper
  def prefixed_cloudinary_url(file_id)
    "http://res.cloudinary.com/postinvoice-com-au/image/upload/#{file_id}"
  end

  def cloudinary_file_name(file_name)
    file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
  end
end
