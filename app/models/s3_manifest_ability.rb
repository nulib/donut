class S3ManifestAbility
  include CanCan::Ability

  def initialize
    can :read, :all
  end
end
