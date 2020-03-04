require 'csv'
require_relative 'photograph'
require_relative 'artist'

class Curator

  attr_reader :photographs,
              :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    @artists.find do |artist|
      artist.id == id
    end
  end

  def photographs_by_artist
    @artists.reduce({}) do |artist_photos, artist|
      @photographs.each do |photo|
        artist_photos[artist] = [] if artist_photos[artist].nil?
        artist_photos[artist] << photo if artist.id == photo.artist_id
      end
      artist_photos
    end
  end

  def artists_with_multiple_photographs
    multi_photo_artists = []
    photographs_by_artist.each do |artist, photos|
      if photos.length > 1
        multi_photo_artists << artist.name
      end
    end
    multi_photo_artists
  end

  def photographs_taken_by_artist_from(country)
    photos_by_artist_from_country = []
    photographs_by_artist.each do |artist, photos|
      if artist.country == country
        photos_by_artist_from_country << photos
      end
    end
    photos_by_artist_from_country.flatten
  end

  def load_photographs(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)

    csv.each do |row|
      @photographs << Photograph.new(row)
    end
  end

  def load_artists(csv_file_path)
    csv = CSV.read(csv_file_path, headers: true, header_converters: :symbol)

    csv.each do |row|
      @artists << Artist.new(row)
    end
  end

  def photographs_taken_between(year_range)
    @photographs.find_all do |photo|
      year_range.include?(photo.year.to_i)
    end
  end

  def artists_photographs_by_age(artist_object)
    artist_photogragh_at_age = {}
    photographs_by_artist.each do |artist, photos|
      if artist == artist_object
        photos.each do |photo|
          artist_photogragh_at_age[photo.year.to_i - artist.born.to_i] = photo.name
        end
      end
    end
    artist_photogragh_at_age
  end
end
