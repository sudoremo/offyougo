module Offyougo
  class App
    CANVAS_WIDTH = 100

    BOX_STYLES = {
      :single => ['┌', '─', '┐', '│', '└', '┘'],
      :double => ['╔', '═', '╗', '║', '╚', '╝']
    }

    def initialize(args)

      @version = File.read('VERSION')
      @vv = VolumeWatcher::MacOSX.new(self)

      @source = nil
      @destination = nil

      @volumes = []

      read_config

      index
    end

    def index
      if @source.nil?
        @source = volumes.first
      end

      render do
        puts "-- Settings --------------------------------------------------------------------".blue
        puts "Source       :".blue + " #{@source || 'none'}".yellow
        puts "Destination  :".blue + " #{@destination || 'none'}".yellow
        puts ("-"*80).blue
        puts
        puts "-- Your command ----------------------------------------------------------------".red
        choose do |menu|
          menu.choices(:copy) { copy }
          menu.choice(:change_source) { change_source }
          menu.choices(:change_destination) { change_destination }
        end
      end
    end

    def change_source
      render do
        choose do |menu|
          volumes.each do |v|
            menu.choices(v.to_sym) do
              @source = v
              index
            end
          end
        end
      end
    end

    def change_destination
      render do
        @destination = ask "Destination directory: ", String do |q|
          q.responses[:not_valid] = 'Please enter a valid, absolute directory path without a trailing slash and any spaces:'
          q.validate = Proc.new do |answer|
            answer.match(/^(\/[a-zA-Z0-9_-]+)+$/) && File.directory?(answer)
          end
        end.to_s

        write_config
        index
      end
    end

    def copy
      render do
        unless File.directory?(@source || '')
          error = 'Source not set or source directory not found'
        end

        unless File.directory?(@destination || '')
          error = 'Destination not set or source directory not found'
        end

        if error
          puts '-- Copy: Error------------------------------------------------------------------'.red
          puts 'Source not set or source directory not found'.red
          puts '--------------------------------------------------------------------------------'.red
          puts
          puts 'Press enter to return.'.blue
          gets
          index
          return
        end

        # ---------------------------------------------------------------
        # Assemble command
        # ---------------------------------------------------------------
        command = [
          'rsync',
          '--recursive',  # recurse into directories
          '--links',      # copy symlinks as symlinks
          '--perms',      # preserve permissions
          '--times',      # preserve times
          '--group',      # preserve group
          '--owner',      # preserve owner
          '--devices',    # preserve device files (super-user only)
          '--specials',   # preserve special files
          '--verbose',    # increase verbosity
          '--progress',   # show process
          @source,
          @destination + '/'
        ]
        puts '-- Prepared rsync command: -----------------------------------------------------'.blue

        puts command.join(' ').yellow
        puts
        unless agree('Continue (yes/no)?')
          index
          return
        end

        # ---------------------------------------------------------------
        # Execute command
        # ---------------------------------------------------------------
        puts
        puts '-- Performing rsync command ----------------------------------------------------'.blue
        success = system command.join(' ')

        # ---------------------------------------------------------------
        # Handle error case
        # ---------------------------------------------------------------
        unless success

          print_red_line ''
          print_red_line ' COPY FAILED'
          print_red_line ''
          print_red_line " Source:      #{@source}"
          print_red_line " Destination: #{@destination}"
          print_red_line ''

          puts
          puts 'Press enter to return.'

          gets
          index
        end

        print_green_line ''
        print_green_line ' COPY SUCCESSFUL'
        print_green_line ''
        print_green_line " Source     : #{@source}"
        print_green_line " Destination: #{@destination}"
        print_green_line ''

        puts
        puts "-- Unmount? --------------------------------------------------------------------".blue
        puts

        if agree('Umount source (yes/no)?')
          unmount(@source)
        else
          index
          return
        end

        # puts
        # puts '                                                                                '.colorize(:background => :green, :color => :black)
        # puts '  COPY SUCCESSFUL                                                               '.colorize(:background => :green, :color => :black)
        # puts "  #{@source} to #{@destination}".colorize(:background => :green, :color => :black)
        # puts '                                                                                '.colorize(:background => :green, :color => :black)

      end
    end

    def unmount(path)
      # ---------------------------------------------------------------
      # Execute command
      # ---------------------------------------------------------------
      puts
      puts '-- Unmounting ------------------------------------------------------------------'.blue
      success = system "diskutil umount #{path}"

      puts

      # ---------------------------------------------------------------
      # Handle error case
      # ---------------------------------------------------------------
      unless success
        print_red_line ''
        print_red_line ' UNMOUNT FAILED'
        print_red_line ''

        puts
        puts 'Press enter to return.'

        gets
        index
      end

      @source = nil

      print_green_line ''
      print_green_line " UNMOUNT SUCCESSFUL. Media #{path} can be safely removed."
      print_green_line ''
      puts
      puts 'Press enter to return.'
      gets
      index
      return
    end

    private

    def print_green_line(text)
      puts (text + " "*(80-text.size)).colorize(:background => :green, :color => :black)
    end

    def print_red_line(text)
      puts (text + " "*(80-text.size)).colorize(:background => :red, :color => :white)
    end

    def config_file
      File.expand_path('~/.offyougo')
    end

    def read_config
      if File.file?(config_file)
        conf = YAML.load_file(config_file)
        @destination = conf[:destination]
      end
    end

    def write_config
      File.open(config_file, 'w') do |f|
        f.write({
          :destination => @destination
        }.to_yaml)
      end
    end

    def volumes
      @vv.scan.sort.to_a.select { |v| v.match(/[A-Z]\d\d\d_[A-Z0-9]+/) }
    end

    def render(&block)
      system "clear" or system "cls"

      puts ("Off You Go                      Version " + IO.read('VERSION') + ', Copyright ©2015 by Remo Fritzsche').yellow
      puts ("-"*80).yellow
      puts

      yield
    end

    def draw_box(options={}, &block)
      options[:style] ||= :single
      options[:title] ||= nil

      chars = BOX_STYLES[options[:style]]

      puts chars[0] + chars[1]*(CANVAS_WIDTH-2) + chars[2]
      yield.split("\n").each do |line|
        print chars[3] + ' '
        print line + (' ' * (CANVAS_WIDTH - 3 - line.size))
        print chars[3] + " \n"
      end
      puts chars[4] + chars[1]*(CANVAS_WIDTH-2) + chars[5]

    end
  end
end