class recurring_flash_job 

    include Sidekiq::Job

    def performance

      puts "Running job at #{Time.now}"

    end

end