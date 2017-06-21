class Ability
  include Hydra::Ability

  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns]

  def can_create_any_work?
    Hyrax.config.curation_concerns.any? do |curation_concern_type|
      can?(:create, curation_concern_type)
    end
  end

  # Define any customized permissions here.
  def custom_permissions
    return unless admin?
    can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
    can [:destroy], ActiveFedora::Base
  end
end
