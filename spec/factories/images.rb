FactoryGirl.define do
  factory :image do
    title ['Test title']
    rights_statement ['http://rightsstatements.org/vocab/NKC/1.0/']
    description ['Test description']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    abstract ['Lemon drops donut gummi bears carrot cake dragée.']
    accession_number 'Lgf0825'
    call_number 'W107.8:Am6'
    catalog_key ['9943338434202441']
    citation ['Test']
    contributor_role ['Joanne	Howell']
    creator_attribution ['Unknown']
    creator_role ['http://id.loc.gov/vocabulary/relators/ill.html']
    genre ['Postmodern']
    physical_description ['Wood 6cm x 7cm']
    related_url_label ['Related Website']
    rights_holder ['Northwestern University Libraries']
    style_period ['Renaissance']
    technique ['Gauche']

    transient do
      user { FactoryGirl.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
