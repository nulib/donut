require 'cancan/matchers'
require 'rails_helper'

RSpec.describe S3ManifestAbility, type: :model do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:presenter) { Hyrax::FileSetPresenter.new(solr_document, ability) }
  let(:attributes) { file.to_solr }
  let(:file) do
    create(:file_set,
           id: '123abc',
           user: user,
           title: ['File title'],
           depositor: user.user_key,
           label: 'filename.tif',
           visibility: 'restricted')
  end
  let(:user) do
    instance_double(User, user_key: 'testuser1')
  end

  describe 'without a user' do
    subject { ability.can?(:read, presenter.id) }

    let(:ability) { S3ManifestAbility.new }

    context 'can read a private FileSet' do
      it { is_expected.to be true }
    end
  end
end
