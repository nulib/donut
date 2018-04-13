Hyrax::FileSetPresenter.class_eval do
  delegate :width, :height, :compression,
           :photometric_interpretation, :samples_per_pixel,
           :x_resolution, :y_resolution, :resolution_unit, :date_time,
           :bits_per_sample, :make, :model, :strip_offsets,
           :rows_per_strip, :strip_byte_counts, :software, :extra_samples,
           to: :solr_document
end
