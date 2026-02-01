class UserEntrySimilaritiesController < ApplicationController
  def create
    ids = params[:entry_similarity_ids].to_s.split(",").reject(&:blank?).map(&:to_i)

    UserEntrySimilarity.transaction do
      ids.each do |entry_similarity_id|
        current_user.user_entry_similarities.find_or_create_by!(entry_similarity_id:)
      end
    end

    redirect_to next_step_path # wherever “Continue” should go
  end
end
