class JobQueue
  before_action :get_doable_jobs

  def self.organize(dependencies)
    unresolved_dependencies = dependencies.dup
    sorted_jobs = []

    until unresolved_dependencies.empty? do
      doable_jobs = get_doable_jobs unresolved_dependencies, sorted_jobs
      raise Exception.new("Not able to resolve dependencies") if doable_jobs.empty?
      sorted_jobs += doable_jobs
      unresolved_dependencies.delete_if {|key,value| sorted_jobs.include? key}
    end

    sorted_jobs
  end

  private

  def self.get_doable_jobs(dependencies, job_array)
    dependencies.select { |dependency| ([*dependency]-job_array).empty? }.keys
  end
end