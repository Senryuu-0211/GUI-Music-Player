require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xff_00ffff)
BOTTOM_COLOR = Gosu::Color.new(0xff_ffffff)
X_LOCATION = 750		#to display track name

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY
	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end

class ArtWork
    attr_accessor :bmp, :dim
    def initialize (file, leftX, topY)
        @bmp = Gosu::Image.new(file)
        @dim = Dimension.new(leftX, topY, leftX + @bmp.width(), topY + @bmp.height())
    end
end

class Album
	  attr_accessor :artist, :title, :artwork, :tracks
	  def initialize (artist, title, artwork, tracks)
		    @artist = artist
        @title = title
		    @artwork = artwork
		    @tracks = tracks
	  end
end

class Track
    attr_accessor :name, :location, :dim
    def initialize (name, location, dim)
        @name = name
        @location = location
        @dim = dim
    end
  end

class Playlist
	attr_accessor :name, :location, :dim
	def initialize(name, location, dim)
		  @name = name
		  @location = location
		  @dim = dim
	end
end

# Put your record definitions here

class MusicPlayerMain < Gosu::Window

    def initialize
        super 1200, 800
        self.caption = "Music Player"
        @track_font = Gosu::Font.new(20)
        @albums = read_albums()
        @album_playing = -1
	      @track_playing = -1
        # Reads in an array of albums from a file and then prints all the albums in the
        # array to the terminal
    end

  # Put in your code here to load albums and tracks
    def read_track(music_file, id)
        name = music_file.gets.chomp  
        location = music_file.gets.chomp  
        leftX = 750
        topY = 50 * id + 50
        rightX = leftX + @track_font.text_width(name)
        bottomY = topY + @track_font.height()
        dimension = Dimension.new(leftX, topY, rightX, bottomY)
        track = Track.new(name, location, dimension)
        return track
    end

    def read_tracks(music_file)
        count = music_file.gets().to_i()
        tracks = Array.new()
        id = 0
        while id < count
           track = read_track(music_file, id)
           tracks << track
           id += 1
        end
        return tracks
    end

    def read_album(music_file, id)
      artist = music_file.gets.chomp
      title = music_file.gets.chomp
      if id % 2 == 0
        leftX = 50
      else
        leftX = 375
      end
      if id <= 1
        topY = 50
      else
        topY = 375
      end
      artwork = ArtWork.new(music_file.gets.chomp, leftX, topY)
      tracks = read_tracks(music_file)
      album = Album.new(artist, title, artwork, tracks)
      return album
    end

    def read_albums()
        music_file = File.new("music.txt", "r")
        count = music_file.gets().to_i()
        albums = Array.new()
        id = 0
        while (id < count)
            album = read_album(music_file, id)
            albums << album
            id += 1
        end
        music_file.close()
        return albums
    end


  # Draws the artwork on the screen for all the albums

    def draw_albums(albums)
    # complete this code
      albums.each do |album|
        album.artwork.bmp.draw(album.artwork.dim.leftX, album.artwork.dim.topY , z = ZOrder::PLAYER)
        if area_clicked(album.artwork.dim.leftX, album.artwork.dim.topY, album.artwork.dim.rightX, album.artwork.dim.bottomY)
          @track_font.draw_text(album.title, 50, 700, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
          @track_font.draw_text(album.artist, 50, 730, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::FUCHSIA)
          draw_rect(album.artwork.dim.leftX - 3, album.artwork.dim.topY - 3, album.artwork.bmp.width + 6, album.artwork.bmp.height + 6, Gosu::Color::BLACK, ZOrder::BACKGROUND)
        end
      end
    end

    def draw_tracks(album)
		  album.tracks.each do |track|
			  display_track(track)
		  end
	  end

    def draw_current_playing(id, album)
      draw_rect(album.tracks[id].dim.leftX - 10, album.tracks[id].dim.topY, 5, @track_font.height(), Gosu::Color::RED, z = ZOrder::PLAYER)
    end
  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

    def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
        if mouse_x >= leftX && mouse_x <= rightX && mouse_y >= topY && mouse_y <= bottomY
          return true
        else 
          return false
        end
    end

  # Takes a String title and an Integer ypos
  # You may want to use the following:
    def display_track(track)
        @track_font.draw_text(track.name, X_LOCATION, track.dim.topY, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
    end

  # Takes a track index and an Album and plays the Track from the Album

    def playTrack(track, album)
     # complete the missing code
            @song = Gosu::Song.new(album.tracks[track].location)
            @song.play(false)
            @song.volume = 0.6
    # Uncomment the following and indent correctly:
    #   end
    # end
    end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

    def draw_background
        draw_quad(0, 0, TOP_COLOR, 0, 800, TOP_COLOR, 1200, 0, BOTTOM_COLOR, 1200, 800, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
	  end

# Not used? Everything depends on mouse actions.

    def update
  # If a new album has just been seleted, and no album was selected before -> start the first song of that album
       if @album_playing >= 0 && @song == nil
          @track_playing = 0
          playTrack(0, @albums[@album_playing])
       end
  
  # If an album has been selecting, play all songs in turn
       if @album_playing >= 0 && @song != nil && (not @song.playing?) && @song.paused? == false
          @track_playing = (@track_playing + 1) % @albums[@album_playing].tracks.length() #% to ensure the index remains within the range of available tracks in the current album.
          playTrack(@track_playing, @albums[@album_playing])
       end
    end

 # Draws the album images and the track list for the selected album

    def draw
        # Complete the missing code
        draw_background
        draw_albums(@albums)
        if @album_playing >= 0
          draw_tracks(@albums[@album_playing])
          draw_current_playing(@track_playing, @albums[@album_playing])
        end
        @track_font.draw_text("Mouse X: #{mouse_x}", 0, 780, ZOrder::UI, 0.5, 0.5, Gosu::Color::BLACK)
        @track_font.draw_text("Mouse Y: #{mouse_y}", 100, 780, ZOrder::UI, 0.5, 0.5, Gosu::Color::BLACK)
        @track_font.draw_text("Hover on album for info. Click to play album/songs. SPACE to play/pause", 50, 15, ZOrder::UI, 0.93, 0.93, Gosu::Color::RED)
        if @song != nil
          @track_font.draw_text("Volume: " + (@song.volume * 100).to_i.to_s + "% (Up/Down keys)", 750, 510, z = 2, 1, 1, Gosu::Color::RED)
          @track_font.draw_text("Left/Right Arrow to skip track, or click to select", 750, 615, z = 2, 1, 1, Gosu::Color::RED)
        end
    end

    def needs_cursor?; true; end

    # If the button area (rectangle) has been clicked on change the background color
    # also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
    # you will learn about inheritance in the OOP unit - for now just accept that
    # these are available and filled with the latest x and y locations of the mouse click.

    def button_down(id)
        case id
        when Gosu::MsLeft

          # If an album has been selected
          if @album_playing >= 0
            # --- Check which track was clicked on ---
            for i in 0..@albums[@album_playing].tracks.length() - 1
              if area_clicked(@albums[@album_playing].tracks[i].dim.leftX, @albums[@album_playing].tracks[i].dim.topY, @albums[@album_playing].tracks[i].dim.rightX, @albums[@album_playing].tracks[i].dim.bottomY)
                #the area to click will be modify based on the song name's length
                playTrack(i, @albums[@album_playing])
                @track_playing = i
                break
              end
            end
          end
  
        # --- Check which album was clicked on ---
          for i in 0..@albums.length() - 1
             if area_clicked(@albums[i].artwork.dim.leftX, @albums[i].artwork.dim.topY, @albums[i].artwork.dim.rightX, @albums[i].artwork.dim.bottomY)
               @album_playing = i
               @song = nil
               break
             end
          end
        when Gosu::KB_SPACE
          if @song.paused?
            @song.play(false)
          elsif @song.playing?
            @song.pause
          end
        when Gosu::KB_DOWN
          if @song != nil
            @song.volume -= 0.1
          end
        when Gosu::KB_UP
          if @song != nil
            @song.volume += 0.1
          end  
        when Gosu::KB_LEFT
          if @track_playing != nil
            if @track_playing > 0
              @track_playing -= 1
            else 
              @track_playing = @albums[@album_playing].tracks.length - 1
            end
            playTrack(@track_playing, @albums[@album_playing])
          end
        when Gosu::KB_RIGHT
          if @track_playing != nil
            if @track_playing < @albums[@album_playing].tracks.length - 1
              @track_playing += 1
            else 
              @track_playing = 0
            end
            playTrack(@track_playing, @albums[@album_playing])
          end
        end
    end
end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0

