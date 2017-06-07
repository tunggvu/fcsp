module JobShare
  def share job
    shares.build job_id: job.id
  end

  def unshare job
    unshare = shares.find_by(job_id: job.id)
    unshare.destroy if unshare
  end
end
