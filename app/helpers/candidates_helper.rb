module CandidatesHelper
  def check_apply_jobs? user_id, job_id
    Candidate.find_by user_id: user_id, job_id: job_id
  end

  def load_avatar_candidate candidate
    # rubocop:disable MultilineTernaryOperator
    def load_avatar_candidate candidate
      image_tag candidate.avatar.present? ? candidate.avatar.picture :
        PictureUploader.new.picture_url,
        size: Settings.employer.candidates.avatar_size, class: "media-photo"
    end
   # rubocop:enable MultilineTernaryOperator
  end
end
