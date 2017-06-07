module ApplyJob
  def apply_job job
    candidates.create job_id: job.id
  end

  def unapply_job job
    candidates.find_by(job_id: job.id).destroy if job.present?
  end
end
