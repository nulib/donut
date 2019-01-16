class DefaultRepresentativeFileActor < Hyrax::Actors::AbstractActor
  def create(env)
    next_actor.create(env) && init_default_representative(env)
  end

  private

    def init_default_representative(env)
      env.curation_concern.tap do |work|
        work.representative_id = work.thumbnail_id = work.ordered_member_ids.first
        work.save!
      end
    end
end
