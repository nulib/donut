# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schemas::Administrative do
  subject(:work) { model_class.new }

  let(:model_class) do
    Class.new(ActiveFedora::Base) do
      include ::Schemas::Administrative

      def save; end # no-op; stubbed save
    end
  end

  it_behaves_like 'a model with admin metadata'
end
