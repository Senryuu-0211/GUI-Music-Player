require './input_functions'
require 'colorize'
# It is suggested that you put together code from your 
# previous tasks to start this. eg:
# 8.1T Read Album with Tracks

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :artist, :title, :date, :genre, :tracks 
	def initialize (artist, title, date, genre, tracks)
		@artist = artist
		@title = title
    @date = date
		@genre = genre
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location
	def initialize (name, location)
		@name = name
		@location = location
	end
end

def read_track(music_file)
	name = music_file.gets()
	location = music_file.gets()
	track = Track.new(name, location)
	return track
end

def read_tracks(music_file)
	count = music_file.gets().to_i()
  	tracks = Array.new()
    i = 0 
	while (i < count)
  	   track = read_track(music_file)
  	   tracks << track
       i += 1
	end
	return tracks
end

def print_tracks(tracks)
	index = 0
	while (index < tracks.length)
     print ("#{index + 1}/ ")
     print_track(tracks[index])
	   index += 1
	end
end
 
def read_album(music_file)
	album_artist = music_file.gets.chomp()
  album_title = music_file.gets.chomp()
  album_date = music_file.gets.chomp()
	album_genre = music_file.gets.chomp()
	tracks = read_tracks(music_file)
	album = Album.new(album_artist, album_title, album_date, album_genre, tracks)
	return album
end

def read_albums(music_file)
    album_count = music_file.gets().to_i()
  	albums = Array.new()
    i = 0 
	while (i < album_count)
  	   album = read_album(music_file)
  	   albums << album
       i += 1
	end
	music_file.close()
  puts("System read in #{album_count} albums")
	return albums   
end

def print_album(album)
  puts("")
	puts('Artist name: ' + album.artist)
	puts('Album name is: ' + album.title)
  puts('Release date is: ' + album.date.to_s)
	puts('Genre is ' + $genre_names[album.genre.to_i])
  print_tracks(album.tracks)
end

def print_albums(albums)
    index = 0
	while (index < albums.length)
	   print_album(albums[index])
	   index += 1
	end
end

def print_track(track)
  	puts(track.name)
	  puts(track.location)
end

def display_albums(albums)
    finished2 = false
    begin
      puts 'Display Albums Menu:'.green
      puts '1 Display all Albums'.green
      puts '2 Display Albums by Genre'.green
      puts '3 Return to Main Menu'.green
      choice2 = read_integer_in_range("Please enter your choice:", 1, 3)
        case choice2
          when 1 
             print_albums(albums)
             puts("Press enter to continue \n")
	           break
          when 2
            puts("Select genre")
            puts("1: Pop".green)
            puts("2: Classic".green)
            puts("3: Jazz".green)
            puts("4: Rock".green)
            puts("5: Return".green)
	          genre_choice = read_integer_in_range("Please enter your choice:", 1, 5)
	          display_albums_by_genre(genre_choice, albums)
            puts("Press enter to continue\n")
            break
          when 3
             finished = true
             break
          else puts("Please select again") 
        end
    end until finished2
end

def display_albums_by_genre(genre, albums)
   i = 0
   while (i < albums.length)
     if albums[i].genre.to_i == genre
       puts("\n Album #{i + 1} ")
       print_album(albums[i])
     end
     i += 1
   end
end

def play_albums(albums)
    i = 0
    while (i < albums.length)
      genres = albums[i].genre.to_i
      puts ("#{i + 1}: " + "Album name: " + albums[i].title + " Artist: " + albums[i].artist + " Genre: " + $genre_names[genres])
      i += 1
    end
    select_album = read_integer_in_range("Enter Album number:", 1, albums.length) 
    tracks_count = albums[select_album - 1].tracks.length
    puts("Album: " + albums[select_album - 1].title)
    puts("There are #{tracks_count} tracks: ")
    for i in 1..tracks_count
      puts "#{i}: #{albums[select_album - 1].tracks[i - 1].name}"
    end
    if (albums[select_album - 1].tracks.length) != 0
      chosen_track = read_integer_in_range("Select a Track to play:", 1, tracks_count)
      print "Playing Track #{chosen_track}: #{albums[select_album - 1].tracks[chosen_track - 1].name} from album #{albums[select_album - 1].title}"
      sleep(3.0)
    else     
      puts("The album is empty")
    end
    puts("\n Press enter to continue\n")
end

def update_albums(albums) 
    i = 0
    while (i < albums.length)
      genres = albums[i].genre.to_i
      puts ("#{i + 1}: " + "Album name: " + albums[i].title + " Artist: " + albums[i].artist + " Genre: " + $genre_names[genres])
      i += 1
    end
    select_update = read_integer_in_range("Enter the Album to edit: ", 1, albums.length)
    puts("What to edit")
    puts("1: Title")
    puts("2: Genre")
    choice3 = read_integer_in_range("Enter selection: ", 1, 2)
    genres2 = albums[select_update - 1].genre.to_i
    case choice3
      when 1
        update_title(albums, select_update, genres2)
      when 2
        update_genre(albums, select_update, genres2)
    end
end 

def update_title(albums, select_update, genres2)
    puts('The current album title is: ', albums[select_update - 1].title)
    new_title = read_string("Enter a new title for the Album: ")
    albums[select_update - 1].title = new_title
    puts ("Album name: " + albums[select_update - 1].title + " Artist: " + albums[select_update - 1].artist + " Genre: " + $genre_names[genres2])
    puts("Press enter to continue\n")
end

def update_genre(albums, select_update, genres2)
  puts('The current album genre is: ', $genre_names[genres2])
  puts("1. Pop")
  puts("2. Classic")
  puts("3. Jazz")
  puts("4. Rock")
  new_genre = read_integer_in_range("Enter number of genre to modify: ", 1, 4)
  genres2 = new_genre
  puts ("Album name: " + albums[select_update - 1].title + " Artist: " + albums[select_update - 1].artist + " Genre: " + $genre_names[genres2])
  puts("Press enter to continue\n")
end

def main_menu(albums)
    finished = false
  begin
    puts 'Main Menu:'
    puts '1. Read in Albums'.green
    puts '2. Display Albums'.green
    puts '3. Select an Album to play'.green
    puts '4. Update an existing Album'.green
    puts '5. Exit the application'.green
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
    when 1
      file_name = read_string("PLease enter albums file name: ")
      music_file = File.new(file_name, "r")
      albums = read_albums(music_file)
    when 2
      if albums == nil
         puts('Please first read in album information!')
      else
         display_albums(albums)
    end
    when 3  
      if albums == nil
        puts('Please first read in album information!')
     else
        play_albums(albums)
    end
    when 4
      if albums == nil
        puts('Please first read in album information!')
     else
        update_albums(albums)
    end
    when 5
      finished = true
    else
      puts "Please select again"
    end
  end until finished
end

def main()
    albums = nil
    main_menu(albums)
end

main()
