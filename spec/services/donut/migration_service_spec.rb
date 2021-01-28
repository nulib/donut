require 'rails_helper'

RSpec.describe Donut::MigrationService do
  let(:file) { 'world.png' }
  let(:file_path) { "#{fixture_path}/images/#{file}" }
  let(:file_set_id) { SecureRandom.uuid }
  let!(:file_set) do
    FactoryBot.create(
      :file_set,
      id: file_set_id, import_url: 'http://aws/world.png'
    )
  end

  let(:id) { SecureRandom.uuid }
  let(:accession_number) { SecureRandom.uuid }
  let(:attributes) do
    {
      'id' => id,
      'depositor' => 'depositor@example.edu',
      'title' => [
        'Knowing their lines: how social boundaries undermine equity-based integration policies in United States and South African schools'
      ],
      'project_name' => ['what is a name'],
      'project_description' => ['cool new project'],
      'proposer' => ['proposer person'],
      'project_manager' => ['manager person'],
      'task_number' => ['big task'],
      'preservation_level' => '1',
      'project_cycle' => ['2021'],
      'status' => 'In progress',
      'abstract' => ["Spock's Beard!"],
      'box_name' => ['This box name'],
      'box_number' => %w[one],
      'folder_name' => ['other name for the folder'],
      'folder_number' => %w[one],
      'legacy_identifier' => %w[legacy-123],
      'nul_use_statement' => [],
      'subject_geographical' => [],
      'subject_temporal' => [],
      'architect' => [RDF.URI('http://vocab.getty.edu/ulan/500006293')],
      'artist' => [RDF.URI('http://vocab.getty.edu/ulan/500283614')],
      'author' => [RDF.URI('http://vocab.getty.edu/ulan/500059498')],
      'cartographer' => [RDF.URI('http://vocab.getty.edu/ulan/500040876')],
      'collector' => [RDF.URI('http://vocab.getty.edu/ulan/500232613')],
      'compiler' => [RDF.URI('http://vocab.getty.edu/ulan/500382433')],
      'composer' => [RDF.URI('http://vocab.getty.edu/ulan/500475850')],
      'designer' => [RDF.URI('http://vocab.getty.edu/ulan/500030701')],
      'director' => [RDF.URI('http://vocab.getty.edu/ulan/500471728')],
      'distributor' => [RDF.URI('http://vocab.getty.edu/ulan/500307592')],
      'donor' => [RDF.URI('http://vocab.getty.edu/ulan/500470438')],
      'draftsman' => [RDF.URI('http://vocab.getty.edu/ulan/500442157')],
      'editor' => [RDF.URI('http://vocab.getty.edu/ulan/500391054')],
      'engraver' => [RDF.URI('http://vocab.getty.edu/ulan/500107899')],
      'illustrator' => [RDF.URI('http://vocab.getty.edu/ulan/500278327')],
      'librettist' => [RDF.URI('http://vocab.getty.edu/ulan/500309555')],
      'musician' => [RDF.URI('http://vocab.getty.edu/ulan/500126712')],
      'performer' => [RDF.URI('http://vocab.getty.edu/ulan/500330448')],
      'photographer' => [RDF.URI('http://vocab.getty.edu/ulan/500006031')],
      'presenter' => [RDF.URI('http://vocab.getty.edu/ulan/500470578')],
      'printer' => [RDF.URI('http://vocab.getty.edu/ulan/500372056')],
      'printmaker' => [RDF.URI('http://vocab.getty.edu/ulan/500013716')],
      'producer' => [RDF.URI('http://vocab.getty.edu/ulan/500330922')],
      'production_manager' => [
        RDF.URI('http://vocab.getty.edu/ulan/500463857')
      ],
      'publisher' => ['Teenage Zines Inc.'],
      'screenwriter' => [RDF.URI('http://vocab.getty.edu/ulan/500485965')],
      'sculptor' => [RDF.URI('http://vocab.getty.edu/ulan/500068127')],
      'sponsor' => [RDF.URI('http://vocab.getty.edu/ulan/500462763')],
      'transcriber' => [RDF.URI('http://vocab.getty.edu/ulan/500341236')],
      'alternate_title' => ['What else should we call this thing anyways'],
      'accession_number' => accession_number,
      'ark' => nil,
      'call_number' => 'loc-123-345',
      'caption' => ['this is a test caption'],
      'catalog_key' => ['what key opens this door'],
      'genre' => [RDF.URI('http://vocab.getty.edu/aat/300055911')],
      'notes' => ["here's a note"],
      'physical_description_material' => %w[metal],
      'physical_description_size' => %w[50kg],
      'provenance' => ['check the records'],
      'related_material' => ['my baseball card collection'],
      'rights_holder' => %w[everyone],
      'scope_and_contents' => ['all the things'],
      'series' => ['the up series'],
      'style_period' => [RDF.URI('http://vocab.getty.edu/aat/300120209')],
      'table_of_contents' => ['first chapter'],
      'technique' => [RDF.URI('http://vocab.getty.edu/aat/300421535')],
      'nul_creator' => [],
      'subject_topical' => [
        RDF.URI('http://id.loc.gov/authorities/subjects/sh85089429')
      ],
      'nul_contributor' => [],
      'resource_type' => ['Image'],
      'creator' => [RDF.URI('http://vocab.getty.edu/ulan/500025598')],
      'contributor' => [RDF.URI('http://vocab.getty.edu/ulan/500106006')],
      'description' => [
        "\"In this paper we argue that although the United States and South Africa have produced qualitatively different national frames about the necessity for racial integration in education, certain practices converge in both nations at the school level that thwart integrationist goals. Drawing on sociologist Jeannie Oakes and colleagues' idea of schools as \"\"zones of mediation\"\" of economic, racial, social, and cultural phenomena, we provide empirical evidence of how a complex set of social interactions, sustained by explicit organized school practices, limit educators' and students' abilities to accept and comply with integrationist aims of equity and the redress of cumulative disadvantages due to past racial discrimination. We discuss how social and symbolic boundaries reproduced by educational actors in everyday school practices illuminate the macromicro tension between the goals of racial integration policy and perceived group interests. Our arguments emerge from thorough analyses of ethnographic, interview, and survey data obtained over a four-year period from multiracial and desegregated schools located in four US and South African cities. \""
      ],
      'keyword' => %w[keyword_1],
      'rights_statement' => ['http://rightsstatements.org/vocab/InC-EDU/1.0/'],
      'date_created' => ['202u'],
      'subject' => ['Free text Uncontrolled Subject'],
      'language' => [RDF.URI('http://id.loc.gov/vocabulary/languages/eng')],
      'identifier' => ['OCLC identifier 123'],
      'based_near' => [RDF.URI('https://sws.geonames.org/4887398/')],
      'related_url' => [RDF.URI('https://meadow.library.northwestern.edu')],
      'bibliographic_citation' => ['some book'],
      'source' => ['Someone']
    }
  end
  let!(:image) { FactoryBot.create(:image, attributes) }
  let(:expected_result) do
    [
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
              term: { id: 'http://id.loc.gov/authorities/subjects/sh85089429' }
            }
          ],
          'ark' => nil,
          'terms_of_use' => nil,
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
          'creator' => [
            { term: { id: 'http://vocab.getty.edu/ulan/500025598' } }
          ],
          'genre' => [{ term: { id: 'http://vocab.getty.edu/aat/300055911' } }],
          'language' => [
            { term: { id: 'http://id.loc.gov/vocabulary/languages/eng' } }
          ],
          'style_period' => [
            { term: { id: 'http://vocab.getty.edu/aat/300120209' } }
          ],
          'subject_geographical' => [],
          'subject_temporal' => [],
          'subject_topical' => [
            {
              term: { id: 'http://id.loc.gov/authorities/subjects/sh85089429' }
            }
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
    ]
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

  it 'transforms image records into the correct hash format' do
    expect(described_class.new(1, true).records).to eq(expected_result)
  end
end
