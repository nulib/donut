require 'rails_helper'
require 'pry'

RSpec.describe Donut::MigrationService do
  subject { records.first }

  let(:records) { described_class.new(1).records }

  let(:file) { 'world.png' }
  let(:file_path) { "#{fixture_path}/images/#{file}" }
  let(:file_set_id) { SecureRandom.uuid }
  let!(:file_set) do
    FactoryBot.create(
      :file_set,
      id: file_set_id,
      import_url: 'http://aws/world.png'
    )
  end

  let(:id) { SecureRandom.uuid }
  let(:accession_number) { SecureRandom.uuid }
  let(:attributes) do
    {
      'abstract' => ["Spock's Beard!"],
      'accession_number' => accession_number,
      'alternate_title' => ['What else should we call this thing anyways'],
      'architect' => [RDF.URI('http://vocab.getty.edu/ulan/500006293')],
      'ark' => '1234',
      'artist' => [RDF.URI('http://vocab.getty.edu/ulan/500283614')],
      'author' => [RDF.URI('http://vocab.getty.edu/ulan/500059498')],
      'based_near' => [RDF.URI('https://sws.geonames.org/4887398/')],
      'bibliographic_citation' => ['some book'],
      'box_name' => ['This box name'],
      'box_number' => %w[one],
      'call_number' => 'loc-123-345',
      'caption' => ['this is a test caption'],
      'cartographer' => [RDF.URI('http://vocab.getty.edu/ulan/500040876')],
      'catalog_key' => ['what key opens this door'],
      'collector' => [RDF.URI('http://vocab.getty.edu/ulan/500232613')],
      'compiler' => [RDF.URI('http://vocab.getty.edu/ulan/500382433')],
      'composer' => [RDF.URI('http://vocab.getty.edu/ulan/500475850')],
      'contributor' => [RDF.URI('http://vocab.getty.edu/ulan/500106006')],
      'creator' => [RDF.URI('http://vocab.getty.edu/ulan/500025598')],
      'date_created' => ['202u'],
      'depositor' => 'depositor@example.edu',
      'description' => [
        "\"In this paper we argue that although the United States and South Africa have produced qualitatively different national frames about the necessity for racial integration in education, certain practices converge in both nations at the school level that thwart integrationist goals. Drawing on sociologist Jeannie Oakes and colleagues' idea of schools as \"\"zones of mediation\"\" of economic, racial, social, and cultural phenomena, we provide empirical evidence of how a complex set of social interactions, sustained by explicit organized school practices, limit educators' and students' abilities to accept and comply with integrationist aims of equity and the redress of cumulative disadvantages due to past racial discrimination. We discuss how social and symbolic boundaries reproduced by educational actors in everyday school practices illuminate the macromicro tension between the goals of racial integration policy and perceived group interests. Our arguments emerge from thorough analyses of ethnographic, interview, and survey data obtained over a four-year period from multiracial and desegregated schools located in four US and South African cities. \""
      ],
      'designer' => [RDF.URI('http://vocab.getty.edu/ulan/500030701')],
      'director' => [RDF.URI('http://vocab.getty.edu/ulan/500471728')],
      'distributor' => [RDF.URI('http://vocab.getty.edu/ulan/500307592')],
      'donor' => [RDF.URI('http://vocab.getty.edu/ulan/500470438')],
      'draftsman' => [RDF.URI('http://vocab.getty.edu/ulan/500442157')],
      'editor' => [RDF.URI('http://vocab.getty.edu/ulan/500391054')],
      'engraver' => [RDF.URI('http://vocab.getty.edu/ulan/500107899')],
      'folder_name' => ['other name for the folder'],
      'folder_number' => %w[one],
      'genre' => [RDF.URI('http://vocab.getty.edu/aat/300055911')],
      'id' => id,
      'identifier' => ['OCLC identifier 123'],
      'illustrator' => [RDF.URI('http://vocab.getty.edu/ulan/500278327')],
      'keyword' => %w[keyword_1],
      'language' => [RDF.URI('http://id.loc.gov/vocabulary/languages/eng')],
      'legacy_identifier' => %w[legacy-123],
      'librettist' => [RDF.URI('http://vocab.getty.edu/ulan/500309555')],
      'musician' => [RDF.URI('http://vocab.getty.edu/ulan/500126712')],
      'notes' => ["here's a note"],
      'nul_contributor' => ['Ojo, Samuel'],
      'nul_creator' => [],
      'nul_use_statement' => [
        'The images on this web site, from material in the collections of the Melville J. Herskovits Library of African Studies of Northwestern University Libraries, are provided for use by its students, faculty and staff, and by other researchers visiting this site, for research consultation and scholarly purposes only. Further distribution and/or any commercial use of the images from this site is not permitted.'
      ],
      'performer' => [RDF.URI('http://vocab.getty.edu/ulan/500330448')],
      'photographer' => [RDF.URI('http://vocab.getty.edu/ulan/500006031')],
      'physical_description_material' => %w[metal],
      'physical_description_size' => %w[50kg],
      'presenter' => [RDF.URI('http://vocab.getty.edu/ulan/500470578')],
      'preservation_level' => '1',
      'printer' => [RDF.URI('http://vocab.getty.edu/ulan/500372056')],
      'printmaker' => [RDF.URI('http://vocab.getty.edu/ulan/500013716')],
      'producer' => [RDF.URI('http://vocab.getty.edu/ulan/500330922')],
      'production_manager' => [
        RDF.URI('http://vocab.getty.edu/ulan/500463857')
      ],
      'project_cycle' => ['2021'],
      'project_description' => ['cool new project'],
      'project_manager' => ['manager person'],
      'project_name' => ['what is a name'],
      'proposer' => ['proposer person'],
      'provenance' => ['check the records'],
      'publisher' => ['Teenage Zines Inc.'],
      'related_material' => ['my baseball card collection'],
      'related_url' => [RDF.URI('https://meadow.library.northwestern.edu')],
      'resource_type' => ['Image'],
      'rights_holder' => %w[everyone],
      'rights_statement' => ['http://rightsstatements.org/vocab/InC-EDU/1.0/'],
      'scope_and_contents' => ['all the things'],
      'screenwriter' => [RDF.URI('http://vocab.getty.edu/ulan/500485965')],
      'sculptor' => [RDF.URI('http://vocab.getty.edu/ulan/500068127')],
      'series' => ['the up series'],
      'source' => ['Someone'],
      'sponsor' => [RDF.URI('http://vocab.getty.edu/ulan/500462763')],
      'status' => 'In progress',
      'style_period' => [RDF.URI('http://vocab.getty.edu/aat/300120209')],
      'subject' => ['Kamara, Kadijatu (Sierra Leonean artist)'],
      'subject_geographical' => [RDF.URI('http://id.worldcat.org/fast/532999')],
      'subject_temporal' => [],
      'subject_topical' => [
        RDF.URI('http://id.loc.gov/authorities/subjects/sh85089429')
      ],
      'table_of_contents' => ['first chapter'],
      'task_number' => ['big task'],
      'technique' => [RDF.URI('http://vocab.getty.edu/aat/300421535')],
      'title' => [
        'Knowing their lines: how social boundaries undermine equity-based integration policies in United States and South African schools'
      ],
      'transcriber' => [RDF.URI('http://vocab.getty.edu/ulan/500341236')]
    }
  end
  let!(:image) { FactoryBot.create(:image, attributes) }
  let(:expected_result) do
    {
      id: id,
      accession_number: accession_number,
      published: false,
      visibility: { id: 'OPEN', scheme: 'visibility' },
      work_type: { id: 'IMAGE', scheme: 'work_type' },
      administrative_metadata: {
        'project_manager' => ['manager person'],
        'project_cycle' => '2021',
        'project_desc' => ['cool new project'],
        'project_name' => ['what is a name'],
        'project_proposer' => ['proposer person'],
        'project_task_number' => ['big task'],
        'library_unit' => nil,
        'status' => { id: 'IN PROGRESS', scheme: 'status' },
        'preservation_level' => { id: '1', scheme: 'preservation_level' }
      },
      descriptive_metadata: {
        'date_created' => [{ edtf: '202X' }],
        'contributor' => [
          {
            role: { id: 'arc', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500006293' }
          },
          {
            role: { id: 'art', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500283614' }
          },
          {
            role: { id: 'aut', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500059498' }
          },
          {
            role: { id: 'ctg', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500040876' }
          },
          {
            role: { id: 'col', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500232613' }
          },
          {
            role: { id: 'com', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500382433' }
          },
          {
            role: { id: 'cmp', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500475850' }
          },
          {
            role: { id: 'ctb', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500106006' }
          },
          {
            role: { id: 'dsr', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500030701' }
          },
          {
            role: { id: 'drt', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500471728' }
          },
          {
            role: { id: 'dst', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500307592' }
          },
          {
            role: { id: 'dnr', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500470438' }
          },
          {
            role: { id: 'drm', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500442157' }
          },
          {
            role: { id: 'edt', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500391054' }
          },
          {
            role: { id: 'egr', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500107899' }
          },
          {
            role: { id: 'ill', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500278327' }
          },
          {
            role: { id: 'lbt', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500309555' }
          },
          {
            role: { id: 'mus', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500126712' }
          },
          {
            role: { id: 'ctb', scheme: 'marc_relator' },
            term: { id: 'info:nul/762ed989-44cd-4e31-ab43-154497be1c3e' }
          },
          {
            role: { id: 'prf', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500330448' }
          },
          {
            role: { id: 'pht', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500006031' }
          },
          {
            role: { id: 'pre', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500470578' }
          },
          {
            role: { id: 'prt', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500372056' }
          },
          {
            role: { id: 'prm', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500013716' }
          },
          {
            role: { id: 'pro', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500330922' }
          },
          {
            role: { id: 'aus', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500485965' }
          },
          {
            role: { id: 'scl', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500068127' }
          },
          {
            role: { id: 'spn', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500462763' }
          },
          {
            role: { id: 'trc', scheme: 'marc_relator' },
            term: { id: 'http://vocab.getty.edu/ulan/500341236' }
          }
        ],
        'subject' => [
          {
            role: { id: 'TOPICAL', scheme: 'subject_role' },
            term: { id: 'info:nul/299222e9-ef5d-4c72-a498-640326ddd058' }
          },
          {
            role: { id: 'GEOGRAPHICAL', scheme: 'subject_role' },
            term: { id: 'http://id.worldcat.org/fast/532999' }
          },
          {
            role: { id: 'TOPICAL', scheme: 'subject_role' },
            term: { id: 'http://id.loc.gov/authorities/subjects/sh85089429' }
          }
        ],
        'ark' => '1234',
        'terms_of_use' =>
          'The images on this web site, from material in the collections of the Melville J. Herskovits Library of African Studies of Northwestern University Libraries, are provided for use by its students, faculty and staff, and by other researchers visiting this site, for research consultation and scholarly purposes only. Further distribution and/or any commercial use of the images from this site is not permitted.',
        'title' =>
          'Knowing their lines: how social boundaries undermine equity-based integration policies in United States and South African schools',
        'abstract' => ["Spock's Beard!"],
        'citation' => ['some book'],
        'caption' => ['this is a test caption'],
        'catalog_key' => ['what key opens this door'],
        'description' => [
          "\"In this paper we argue that although the United States and South Africa have produced qualitatively different national frames about the necessity for racial integration in education, certain practices converge in both nations at the school level that thwart integrationist goals. Drawing on sociologist Jeannie Oakes and colleagues' idea of schools as \"\"zones of mediation\"\" of economic, racial, social, and cultural phenomena, we provide empirical evidence of how a complex set of social interactions, sustained by explicit organized school practices, limit educators' and students' abilities to accept and comply with integrationist aims of equity and the redress of cumulative disadvantages due to past racial discrimination. We discuss how social and symbolic boundaries reproduced by educational actors in everyday school practices illuminate the macromicro tension between the goals of racial integration policy and perceived group interests. Our arguments emerge from thorough analyses of ethnographic, interview, and survey data obtained over a four-year period from multiracial and desegregated schools located in four US and South African cities. \""
        ],
        'folder_name' => ['other name for the folder'],
        'folder_number' => ['one'],
        'identifier' => ['OCLC identifier 123'],
        'keywords' => ['keyword_1'],
        'legacy_identifier' => ['legacy-123'],
        'notes' => ["here's a note"],
        'physical_description_material' => ['metal'],
        'physical_description_size' => ['50kg'],
        'provenance' => ['check the records'],
        'publisher' => ['Teenage Zines Inc.'],
        'related_material' => ['my baseball card collection'],
        'rights_holder' => ['everyone'],
        'scope_and_contents' => ['all the things'],
        'series' => ['the up series'],
        'source' => ['Someone'],
        'table_of_contents' => ['first chapter'],
        'location' => [{ term: { id: 'https://sws.geonames.org/4887398' } }],
        'creator' => [{ id: 'http://vocab.getty.edu/ulan/500025598' }],
        'genre' => [{ term: { id: 'http://vocab.getty.edu/aat/300055911' } }],
        'language' => [
          { term: { id: 'http://id.loc.gov/vocabulary/languages/eng' } }
        ],
        'style_period' => [
          { term: { id: 'http://vocab.getty.edu/aat/300120209' } }
        ],
        'technique' => [
          { term: { id: 'http://vocab.getty.edu/aat/300421535' } }
        ]
      },
      file_sets: [
        {
          id: file_set_id,
          accession_number: "#{accession_number}_donut_01",
          role: 'am',
          metadata: {
            location: 's3:///f794b23c0c6fe1083d0ca8b58261a078cd968967',
            original_filename: 'world.png'
          }
        }
      ]
    }
  end

  before do
    Hydra::Works::AddFileToFileSet.call(
      file_set,
      File.open(file_path, 'rb'),
      :original_file
    )
    image.ordered_members << file_set
    image.save!
  end

  it 'matches' do
    expect(described_class.new(1).records.first).to eq(expected_result)
  end
end
