module BookmarkJob
  def bookmark job
    bookmarks.create job_id: job.id
  end

  def unbookmark job
    bookmarks.find_by(job_id: job.id).destroy
  end
end
