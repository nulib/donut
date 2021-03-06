class Ability
  include Hydra::Ability

  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns]

  def can_create_any_work?
    Hyrax.config.curation_concerns.any? do |curation_concern_type|
      can?(:create, curation_concern_type)
    end
  end

  def can_create_single_use_links?
    current_user&.groups&.include?('unit_viewers')
  end

  # Define any customized permissions here.
  def custom_permissions
    can [:index, :show, :detail, :read], Batch if current_user&.groups&.include?('rdc_managers')
    return unless admin?
    can [:index, :show, :detail, :read], Batch
    can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
    can [:edit, :destroy], ActiveFedora::Base
    can :edit, String
  end
end
