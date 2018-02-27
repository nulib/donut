
namespace :s3 do
  desc 'Generate S3 bucket for dev/staging'
  task generate_bucket: :environment do
    Aws::S3::Client.new.create_bucket(bucket: Settings.aws.buckets.batch)
  end

  desc 'populate s3 buckets with test data'
  task populate_bucket: :environment do
    s3 = Aws::S3::Resource.new
    Dir.chdir('spec/fixtures/csv')
    Dir.glob('**/*').each do |file|
      next if File.directory?(file)
      obj = s3.bucket(Settings.aws.buckets.batch).object(file)
      obj.upload_file(file)
    end
  end

  desc 'create and populate a s3 bucket with test data'
  task :setup do
    Rake::Task['s3:generate_bucket'].invoke
    Rake::Task['s3:populate_bucket'].invoke
  end

  desc 'removes files from s3 bucket'
  task empty_bucket: :environment do
    client = Aws::S3::Client.new
    objs = client.list_objects_v2(bucket: Settings.aws.buckets.batch)
    objs.contents.each do |obj|
      client.delete_object(bucket: Settings.aws.buckets.batch, key: obj.key)
    end
  end

  desc 'deletes an empty bucket'
  task delete_bucket: :environment do
    Aws::S3::Client.new.delete_bucket(bucket: Settings.aws.buckets.batch)
  end

  desc 'empties and deletes the test bucket'
  task :teardown do
    Rake::Task['s3:empty_bucket'].invoke
    Rake::Task['s3:delete_bucket'].invoke
  end
end
