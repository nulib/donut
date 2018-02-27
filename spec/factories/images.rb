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
    citation ['Test']
    contributor_role ['Joanne	Howell']
    creator_role ['http://id.loc.gov/vocabulary/relators/ill.html']
    genre ['Postmodern']
    provenance ['The example provenance']
    physical_description ['Wood 6cm x 7cm']
    rights_holder ['Northwestern University Libraries']
    style_period ['Renaissance']
    technique ['Gauche']
    nul_creator ['Willie Wildcat']
    nul_subject ['Just Northwestern Things']
    nul_contributor ['ContribCat']

    transient do
      user { FactoryBot.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
