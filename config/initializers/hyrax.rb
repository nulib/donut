require 'solrizer'

Hyrax.config do |config|
  # Injected via `rails g hyrax:work Image`
  config.register_curation_concern :image
  # Register roles that are expected by your implementation.
  # @see Hyrax::RoleRegistry for additional details.
  # @note there are magical roles as defined in Hyrax::RoleRegistry::MAGIC_ROLES
  # config.register_roles do |registry|
  #   registry.add(name: 'captaining', description: 'For those that really like the front lines')
  # end

  # When an admin set is created, we need to activate a workflow.
  # The :default_active_workflow_name is the name of the workflow we will activate.
  # @see Hyrax::Configuration for additional details and defaults.
  # config.default_active_workflow_name = 'default'

  # Email recipient of messages sent via the contact form
  # config.contact_email = "repo-admin@example.org"

  # Text prefacing the subject entered in the contact form
  # config.subject_prefix = "Contact form:"

  config.realtime_notifications = false
  # How many notifications should be displayed on the dashboard
  # config.max_notifications_for_dashboard = 5

  # How often clients should poll for notifications
  # config.notifications_update_poll_interval = 30.seconds

  # How frequently should a file be fixity checked
  # config.max_days_between_fixity_checks = 7

  # Enable displaying usage statistics in the UI
  # Defaults to false
  # Requires a Google Analytics id and OAuth2 keyfile.  See README for more info
  # config.analytics = false

  # Google Analytics tracking ID to gather usage statistics
  # config.google_analytics_id = 'UA-99999999-1'

  # Date you wish to start collecting Google Analytic statistics for
  # Leaving it blank will set the start date to when ever the file was uploaded by
  # NOTE: if you have always sent analytics to GA for downloads and page views leave this commented out
  # config.analytic_start_date = DateTime.new(2014, 9, 10)

  # Enables a link to the citations page for a work
  # Default is false
  # config.citations = false

  # Where to store tempfiles, leave blank for the system temp directory (e.g. /tmp)
  # config.temp_file_base = '/home/developer1'

  # Hostpath to be used in Endnote exports
  # config.persistent_hostpath = 'http://localhost/files/'

  # If you have ffmpeg installed and want to transcode audio and video set to true
  config.enable_ffmpeg = true

  # Hyrax uses NOIDs for files and collections instead of Fedora UUIDs
  # where NOID = 10-character string and UUID = 32-character string w/ hyphens
  config.enable_noids = false

  # Template for your repository's NOID IDs
  # config.noid_template = ".reeddeeddk"

  # Use the database-backed minter class
  # config.noid_minter_class = ActiveFedora::Noid::Minter::Db

  # Store identifier minter's state in a file for later replayability
  # config.minter_statefile = '/tmp/minter-state'

  # Prefix for Redis keys
  config.redis_namespace = 'donut'.freeze

  # Path to the file characterization tool
  config.fits_path = Settings.fits.path

  # Path to the file derivatives creation tool
  # config.libreoffice_path = "soffice"

  # How many seconds back from the current time that we should show by default of the user's activity on the user's dashboard
  # config.activity_to_show_default_seconds_since_now = 24*60*60

  # Hyrax can integrate with Zotero's Arkivo service for automatic deposit
  # of Zotero-managed research items.
  # config.arkivo_api = false

  # Location autocomplete uses geonames to search for named regions
  # Username for connecting to geonames
  config.geonames_username = Settings.geonames_username

  # Should the acceptance of the licence agreement be active (checkbox), or
  # implied when the save button is pressed? Set to true for active
  # The default is true.
  # config.active_deposit_agreement_acceptance = true

  # Should work creation require file upload, or can a work be created first
  # and a file added at a later time?
  # The default is true.
  # config.work_requires_files = true

  # Enable IIIF image service. This is required to use the
  # UniversalViewer-ified show page
  #
  # If you have run the riiif generator, an embedded riiif service
  # will be used to deliver images via IIIF. If you have not, you will
  # need to configure the following other configuration values to work
  # with your image server:
  #
  #   * iiif_image_url_builder
  #   * iiif_info_url_builder
  #   * iiif_image_compliance_level_uri
  #   * iiif_image_size_default
  #
  # Default is false
  config.iiif_image_server = true

  # Returns a URL that resolves to an image provided by a IIIF image server
  config.iiif_image_url_builder = lambda do |file_id, _base_url, size|
    IiifDerivativeService.resolve(file_id, extra_path: "full/#{size}/0/default.jpg")
  end
  # config.iiif_image_url_builder = lambda do |file_id, base_url, size|
  #   "#{base_url}/downloads/#{file_id.split('/').first}"
  # end

  # Returns a URL that resolves to an info.json file provided by a IIIF image server
  config.iiif_info_url_builder = lambda do |file_id, _base_url|
    IiifDerivativeService.resolve(file_id)
  end

  # config.iiif_info_url_builder = lambda do |_, _|
  #   ""
  # end

  # Returns a URL that indicates your IIIF image server compliance level
  # config.iiif_image_compliance_level_uri = 'http://iiif.io/api/image/2/level2.json'

  # Returns a IIIF image size default
  # config.iiif_image_size_default = '600,'

  # Should a button with "Share my work" show on the front page to all users (even those not logged in)?
  # config.display_share_button_when_not_logged_in = true

  # The user who runs batch jobs. Update this if you aren't using emails
  config.batch_user_key = Settings.system_user

  # The user who runs fixity check jobs. Update this if you aren't using emails
  config.audit_user_key = Settings.system_user
  #
  # The banner image. Should be 5000px wide by 1000px tall
  # config.banner_image = 'https://cloud.githubusercontent.com/assets/92044/18370978/88ecac20-75f6-11e6-8399-6536640ef695.jpg'

  # Temporary paths to hold uploads before they are ingested into FCrepo
  # These must be lambdas that return a Pathname. Can be configured separately
  #  config.upload_path = ->() { Rails.root + 'tmp' + 'uploads' }
  #  config.cache_path = ->() { Rails.root + 'tmp' + 'uploads' + 'cache' }
  config.upload_path = lambda {
    Pathname(Settings.upload_path || (Settings.aws.buckets.upload ? 'uploads' : Rails.root + 'tmp' + 'uploads'))
  }

  # Location on local file system where derivatives will be stored
  # If you use a multi-server architecture, this MUST be a shared volume
  config.derivatives_path = Pathname(Settings.derivatives_path || Rails.root.join('tmp', 'derivatives'))

  # Should schema.org microdata be displayed?
  # config.display_microdata = true

  # What default microdata type should be used if a more appropriate
  # type can not be found in the locale file?
  # config.microdata_default_type = 'http://schema.org/CreativeWork'

  # Location on local file system where uploaded files will be staged
  # prior to being ingested into the repository or having derivatives generated.
  # If you use a multi-server architecture, this MUST be a shared volume.
  config.working_path = Pathname(Settings.working_path || Rails.root.join('tmp', 'uploads'))

  # Should the media display partial render a download link?
  # config.display_media_download_link = true

  # A configuration point for changing the behavior of the license service
  #   @see Hyrax::LicenseService for implementation details
  # config.license_service_class = Hyrax::LicenseService

  # Labels for display of permission levels
  # config.permission_levels = { "View/Download" => "read", "Edit access" => "edit" }

  # Labels for permission level options used in dropdown menus
  # config.permission_options = { "Choose Access" => "none", "View/Download" => "read", "Edit" => "edit" }

  # Labels for owner permission levels
  # config.owner_permission_levels = { "Edit Access" => "edit" }

  # Path to the ffmpeg tool
  config.ffmpeg_path = Settings.ffmpeg.path

  # Max length of FITS messages to display in UI
  # config.fits_message_length = 5

  # ActiveJob queue to handle ingest-like jobs
  config.ingest_queue_name = Settings.aws&.queues&.ingest || :default

  ## Attributes for the lock manager which ensures a single process/thread is mutating a ore:Aggregation at once.
  # How many times to retry to acquire the lock before raising UnableToAcquireLockError
  # config.lock_retry_count = 600 # Up to 2 minutes of trying at intervals up to 200ms
  #
  # Maximum wait time in milliseconds before retrying. Wait time is a random value between 0 and retry_delay.
  # config.lock_retry_delay = 200
  #
  # How long to hold the lock in milliseconds
  # config.lock_time_to_live = 60_000

  ## Do not alter unless you understand how ActiveFedora handles URI/ID translation
  # config.translate_id_to_uri = ActiveFedora::Noid.config.translate_id_to_uri
  # config.translate_uri_to_id = ActiveFedora::Noid.config.translate_uri_to_id

  ## Fedora import/export tool
  #
  # Path to the Fedora import export tool jar file
  # config.import_export_jar_file_path = "tmp/fcrepo-import-export.jar"
  #
  # Location where BagIt files should be exported
  # config.bagit_dir = "tmp/descriptions"

  # If browse-everything has been configured, load the configs.  Otherwise, set to nil.
  begin
    if defined? BrowseEverything
      config.browse_everything = BrowseEverything.config
    else
      Rails.logger.warn 'BrowseEverything is not installed'
    end
  rescue Errno::ENOENT
    config.browse_everything = nil
  end
end

Date::DATE_FORMATS[:standard] = '%m/%d/%Y'

# Qa::Authorities::Local.register_subauthority('subjects', 'Qa::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('languages', 'Qa::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('genres', 'Qa::Authorities::Local::TableBasedAuthority')

Hyrax::CurationConcern.actor_factory.swap(
  Hyrax::Actors::CreateWithFilesActor,
  Hyrax::Actors::CreateWithFilesOrderedMembersActor
)

Hyrax::CurationConcern.actor_factory.swap(
  Hyrax::Actors::CreateWithRemoteFilesActor,
  Hyrax::Actors::CreateWithRemoteFilesOrderedMembersActor
)

Hyrax::CurationConcern.actor_factory.insert_before(
  Hyrax::Actors::CreateWithRemoteFilesOrderedMembersActor,
  DefaultRepresentativeFileActor
)
