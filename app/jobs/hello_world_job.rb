class HelloWorldJob < ApplicationJob
  queue_as :default

  # Job classes must have a method called `perform`
  # to run the job in the backgroun you execute: HelloWorldJob.perform_later('Hello')
  # to run the job in the right way you execute: HelloWorldJob.perform_now('Hello)
  # Rails gives you different options for running the job such as `wait` which 
  # you can use with the `set` command as in:
  # HelloWorldJob.set(wait: 1.day).perform_later('Hello')
  def perform(word)
    # puts '--------------'
    put_line
    puts "The word is #{word} ð"
    put_line
    # puts '--------------'
  end

  private
  def put_line
    puts '--------------'
  end
end
