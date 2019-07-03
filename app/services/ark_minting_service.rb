class ArkMintingService
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  attr_reader :work

  def self.mint_identifier_for(work)
    ArkMintingService.new(work).run
  end

  def initialize(obj)
    @work = obj
  end

  def run
    return unless identifier_server_reachable?
    if work.ark.present?
      update_metadata
    else
      mint_ark
    end
  end

  private

    def update_metadata
      return if minter_user == 'apitest'
      minter.modify(work.ark, metadata)
    rescue => err
      Rails.warn("Unable to update metadata for ARK #{work.ark} for work #{work.id}: #{err.message}")
      Honeybadger.notify(err)
    end

    def mint_ark
      work.ark = minter.mint(metadata).id
      work.save
    rescue => err
      Rails.warn("Unable to mint ARK for work #{work.id}: #{err.message}")
      Honeybadger.notify(err)
    end

    def minter_user
      Ezid::Client.config.user
    end

    def minter
      Ezid::Identifier
    end

    # Any error raised during connection is considered false
    def identifier_server_reachable?
      Ezid::Client.new.server_status.up?
    rescue
      false
    end

    def metadata
      {
        'datacite.creator' => creator,
        'datacite.title' => title,
        'datacite.publisher' => publisher,
        'datacite.publicationyear' => date_created,
        'datacite.resourcetype' => resource_type,
        target: url
      }
    end

    def creator
      return 'Unknown' if work.creator.empty?
      work.creator.join('; ')
    end

    def title
      return 'Unknown' if work.title.empty?
      work.title.join('; ')
    end

    def publisher
      return 'Unknown' if work.publisher.empty?
      work.publisher.join('; ')
    end

    def date_created
      return 'Unknown' if work.date_created.empty?
      work.date_created.join('; ')
    end

    # We need to map the available options in the resource_types.yml file to what ezid expects.
    # rubocop:disable Metrics/MethodLength
    def ezid_map
      {
        'Audio' =>                        'Sound',
        'Book' =>                         'Text',
        'Dataset' =>                      'Dataset',
        'Dissertation' =>                 'Text',
        'Image' =>                        'Image',
        'Article' =>                      'Text',
        'Masters Thesis' =>               'Text',
        'Part of Book' =>                 'Text',
        'Poster' =>                       'Text',
        'Project' =>                      'Other',
        'Report' =>                       'Text',
        'Research Paper' =>               'Text',
        'Video' =>                        'Audiovisual',
        'Other' =>                        'Other',
        'Capstone Project' =>             'Text',
        'Conference Proceeding' =>        'Text',
        'Journal' =>                      'Text',
        'Map or Cartographic Material' => 'Image',
        'Software or Program Code' =>     'Software',
        'Presentation' =>                 'Other'
      }
    end
    # rubocop:enable Metrics/MethodLength

    def resource_type
      return 'Other' if work.resource_type.empty?
      # Switch out the hyrax types for ezid approved ones.
      types = work.resource_type.map { |x| ezid_map.fetch(x) }
      # EZID can only accomodate a single resource type for an ARK, but hyrax can support many
      # so as a workaround we'll just send the first one
      types.first
    end

    def url
      polymorphic_url(work, host: Rails.application.secrets.host || 'localhost:3000')
    end
end
