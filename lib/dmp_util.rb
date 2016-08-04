# -*- encoding : utf-8 -*-

class DmpUtil
  STATIC_IMG_DOWNLOAD_FILENAME = ENV['GENERATED_MPC_STATIC_IMG_LOCATION'].freeze
  FIREFOX_PATH = ENV['FIREFOX_EXECUTABLE_PATH'].freeze
  MPC_STATIC_IMG_SITE = ENV['MPC_STATIC_IMAGE_URL'].freeze
  FINAL_DIRECTORY_OF_IMG = Rails.root.join('public/images/orbit').freeze

  class << self
    def generate_image(designation, date)
      pid = fork do
        call_firefox(CGI.escape(designation), date)
      end
      monitor
      move(date)
      Process.kill('KILL', pid)
      Process.wait
    end

    private

    def monitor
      previous_size = 0
      size_matches = 0
      sleep_time = 1
      15.times do
        sleep sleep_time
        size = File.file?(STATIC_IMG_DOWNLOAD_FILENAME) ? File.size(STATIC_IMG_DOWNLOAD_FILENAME) : 0
        if size > 0
          sleep_time = 1
          if previous_size == size
            sleep_time = 1
            size_matches += 1
            break if size_matches >= 3
          else
            size_matches = 0
            previous_size = size
            sleep_time *= 2 unless sleep_time == 4
          end
        else
          sleep_time *= 2 unless sleep_time == 4
        end
      end
    end

    def filename(date)
      "#{FINAL_DIRECTORY_OF_IMG}/#{formatted_date(date)}.png"
    end

    def move(date)
      FileUtils.move STATIC_IMG_DOWNLOAD_FILENAME, filename(date)
    end

    def formatted_date(date)
      date = date.is_a?(String) ? Time.zone.parse(date) : date
      @_formatted_date ||= "#{date.year}-#{date.month}-#{date.day}"
    end

    def call_firefox(designation, date)
      exec "#{FIREFOX_PATH} -url '#{MPC_STATIC_IMG_SITE}?designation=#{designation}&date=#{formatted_date(date)}'"
    end
  end
end
