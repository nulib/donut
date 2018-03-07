
namespace :s3 do
  desc 'Create all configured S3 buckets'
  task create_buckets: :environment do
    Settings.aws.buckets.to_h.values.each do |bucket|
      bucket = Aws::S3::Bucket.new(bucket)
      bucket.create unless bucket.exists?
    end
  end

  desc 'Populate S3 batch bucket with test data'
  task populate_batch_bucket: :environment do
    s3 = Aws::S3::Resource.new
    Dir.chdir('spec/fixtures/csv')
    Dir.glob('**/*').each do |file|
      next if File.directory?(file)
      obj = s3.bucket(Settings.aws.buckets.batch).object(file)
      obj.upload_file(file) unless obj.exists?
    end
  end

  desc 'Create buckets and populate with test batch data'
  task :setup do
    Rake::Task['s3:create_buckets'].invoke
    Rake::Task['s3:populate_batch_bucket'].invoke
  end

  desc 'Empty configured S3 buckets'
  task empty_buckets: :environment do
    client = Aws::S3::Client.new
    Settings.aws.buckets.to_h.values.each do |bucket|
      objs = client.list_objects_v2(bucket: bucket)
      objs.contents.each do |obj|
        client.delete_object(bucket: bucket, key: obj.key)
      end
    end
  end

  desc 'Delete configured S3 buckets'
  task delete_buckets: :environment do
    Settings.aws.buckets.to_h.values.each do |bucket|
      Aws::S3::Client.new.delete_bucket(bucket: bucket)
    end
  end

  desc 'Empty and delete the batch bucket'
  task :teardown do
    Rake::Task['s3:empty_buckets'].invoke
    Rake::Task['s3:delete_buckets'].invoke
  end
end
