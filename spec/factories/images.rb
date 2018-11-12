FactoryBot.define do
  factory :image do
    title ['Test title']
    alternate_title ['Alternate Title 1']
    rights_statement ['http://rightsstatements.org/vocab/NKC/1.0/']
    description ['Test description']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    abstract ['Lemon drops donut gummi bears carrot cake.']
    accession_number 'Lgf0825'
    ark 'ark:/12345/12345'
    call_number 'W107.8:Am6'
    caption ['This is the caption seen on the image']
    catalog_key ['9943338434202441']
    date_created ['197x']
    provenance ['The example provenance']
    physical_description_size ['Wood 6cm x 7cm']
    rights_holder ['Northwestern University Libraries']
    nul_creator ['Willie Wildcat']
    nul_contributor ['ContribCat']
    box_name ['A good box name']
    box_number ['42']
    legacy_identifier ['old_images_pid', 'another pid']
    folder_name ['The folder name']
    folder_number ['99']
    preservation_level '1'
    date_modified { Hyrax::TimeService.time_in_utc }
    date_uploaded { Time.current.ctime }

    transient do
      user { FactoryBot.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
