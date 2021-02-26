workers_count = Integer(ENV['WEB_CONCURRENCY'] || 3)
threads_count = Integer(ENV['MAX_THREADS'] || 6)
threads threads_count, threads_count

if workers_count > 1
  preload_app!
  workers workers_count
end

rackup      DefaultRackup
port        ENV['PORT']     || 5000
environment ENV['RACK_ENV'] || 'development'