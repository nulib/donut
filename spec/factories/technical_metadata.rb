FactoryBot.define do
  factory :technical_metadata do
    image_width '4'
    image_height '10'
    compression 'uncompressed'
    photometric_interpretation 'RGB'
    samples_per_pixel '3'
    x_resolution '600'
    y_resolution '600'
    resolution_unit 'inches'
    date_time '2017:09:21 10:42:06-05:00'
    bits_per_sample '8 8 8'
    make 'i2S, Corp.'
    model 'SupraScanQuartzA1 [SN: 331001] - CamQuartzHD [SN: 331001]'
    strip_offsets '19526'
    rows_per_strip '7341'
    strip_byte_counts '159116175'
    software 'Adobe Photoshop CC 2015 (Macintosh)'
    exif_tool_version '10.1'
    extra_samples 'uh sample data'
    exif_all_data '{ cool: \'hash\' }'

    transient do
      file_set { FactoryBot.create(:file_set) }
    end

    after(:build) do |techmd, evaluator|
      techmd.file_set_id = evaluator.file_set.id
    end
  end
end
