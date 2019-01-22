class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/images"
  end

  process resize_to_fit: [800, 1200]

  version :thumb do
    process resize_to_fit: [200, 300]
  end

  process :optimize => [{ quiet: true, quality: 80, level: 1 }]

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg png)
  end

  def filename
    "#{file.basename}_#{secure_token(8)}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token(length=16)
    SecureRandom.hex(length)
  end

end
