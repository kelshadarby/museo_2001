require 'minitest/autorun'
require 'minitest/pride'
require './lib/curator'
require './lib/artist'
require './lib/photograph'

class CuratorTest < Minitest::Test
  def test_it_exists
    curator = Curator.new

    assert_instance_of Curator, curator
  end

  def test_it_can_have_attributes
    curator = Curator.new

    assert_equal [], curator.photographs
    assert_equal [], curator.artists
  end

  def test_it_can_add_photographs
    curator = Curator.new
    photo_1 = Photograph.new({
         id: "1",
         name: "Rue Mouffetard, Paris (Boy with Bottles)",
         artist_id: "1",
         year: "1954"
    })
    photo_2 = Photograph.new({
         id: "2",
         name: "Moonrise, Hernandez",
         artist_id: "2",
         year: "1941"
    })
    curator.add_photograph(photo_1)
    curator.add_photograph(photo_2)

    assert_equal [photo_1, photo_2], curator.photographs
  end

  def test_it_can_add_artists
    curator = Curator.new
    artist_1 = Artist.new({
        id: "1",
        name: "Henri Cartier-Bresson",
        born: "1908",
        died: "2004",
        country: "France"
    })
    artist_2 = Artist.new({
        id: "2",
        name: "Ansel Adams",
        born: "1902",
        died: "1984",
        country: "United States"
    })
    curator.add_artist(artist_1)
    curator.add_artist(artist_2)

    assert_equal [artist_1, artist_2], curator.artists
  end

  def test_it_can_find_artist_by_id
    curator = Curator.new
    artist_1 = Artist.new({
        id: "1",
        name: "Henri Cartier-Bresson",
        born: "1908",
        died: "2004",
        country: "France"
    })
    artist_2 = Artist.new({
        id: "2",
        name: "Ansel Adams",
        born: "1902",
        died: "1984",
        country: "United States"
    })
    curator.add_artist(artist_1)
    curator.add_artist(artist_2)

    assert_equal artist_1, curator.find_artist_by_id("1")

    curator_2 = Curator.new
    curator_2.load_artists('./data/artists.csv')
    diane_arbus = curator_2.artists[2]

    assert_equal diane_arbus, curator_2.find_artist_by_id("3")
  end

  def test_it_can_tell_photographs_by_artist
    curator = Curator.new
    photo_1 = Photograph.new({
         id: "1",
         name: "Rue Mouffetard, Paris (Boy with Bottles)",
         artist_id: "1",
         year: "1954"
    })
    photo_2 = Photograph.new({
         id: "2",
         name: "Moonrise, Hernandez",
         artist_id: "2",
         year: "1941"
    })
    photo_3 = Photograph.new({
         id: "3",
         name: "Identical Twins, Roselle, New Jersey",
         artist_id: "3",
         year: "1967"
    })
    photo_4 = Photograph.new({
         id: "4",
         name: "Monolith, The Face of Half Dome",
         artist_id: "3",
         year: "1927"
    })
    artist_1 = Artist.new({
         id: "1",
         name: "Henri Cartier-Bresson",
         born: "1908",
         died: "2004",
         country: "France"
    })
    artist_2 = Artist.new({
         id: "2",
         name: "Ansel Adams",
         born: "1902",
         died: "1984",
         country: "United States"
    })
    artist_3 = Artist.new({
         id: "3",
         name: "Diane Arbus",
         born: "1923",
         died: "1971",
         country: "United States"
    })
    curator.add_artist(artist_1) #52340
    curator.add_artist(artist_2) # 6c20870
    curator.add_artist(artist_3) # 5ba0c70
    curator.add_photograph(photo_1) #c6933180
    curator.add_photograph(photo_2) #c6c28e58
    curator.add_photograph(photo_3) #5bb9ef0
    curator.add_photograph(photo_4) #6b931f0

    expected = {
      artist_1 => [
        photo_1
      ],
      artist_2 => [
        photo_2
      ],
      artist_3 => [
        photo_3,
        photo_4
      ]
    }

    assert_equal expected, curator.photographs_by_artist
  end

  def test_it_can_tell_artists_with_multiple_photographs
    curator = Curator.new
    photo_1 = Photograph.new({
         id: "1",
         name: "Rue Mouffetard, Paris (Boy with Bottles)",
         artist_id: "1",
         year: "1954"
    })
    photo_2 = Photograph.new({
         id: "2",
         name: "Moonrise, Hernandez",
         artist_id: "2",
         year: "1941"
    })
    photo_3 = Photograph.new({
         id: "3",
         name: "Identical Twins, Roselle, New Jersey",
         artist_id: "3",
         year: "1967"
    })
    photo_4 = Photograph.new({
         id: "4",
         name: "Monolith, The Face of Half Dome",
         artist_id: "3",
         year: "1927"
    })
    artist_1 = Artist.new({
         id: "1",
         name: "Henri Cartier-Bresson",
         born: "1908",
         died: "2004",
         country: "France"
    })
    artist_2 = Artist.new({
         id: "2",
         name: "Ansel Adams",
         born: "1902",
         died: "1984",
         country: "United States"
    })
    artist_3 = Artist.new({
         id: "3",
         name: "Diane Arbus",
         born: "1923",
         died: "1971",
         country: "United States"
    })
    curator.add_artist(artist_1) #52340
    curator.add_artist(artist_2) # 6c20870
    curator.add_artist(artist_3) # 5ba0c70
    curator.add_photograph(photo_1) #c6933180
    curator.add_photograph(photo_2) #c6c28e58
    curator.add_photograph(photo_3) #5bb9ef0
    curator.add_photograph(photo_4) #6b931f0

    assert_equal ["Diane Arbus"], curator.artists_with_multiple_photographs
  end

  def test_it_can_tell_photographs_taken_by_artist_from_a_country
    curator = Curator.new
    photo_1 = Photograph.new({
         id: "1",
         name: "Rue Mouffetard, Paris (Boy with Bottles)",
         artist_id: "1",
         year: "1954"
    })
    photo_2 = Photograph.new({
         id: "2",
         name: "Moonrise, Hernandez",
         artist_id: "2",
         year: "1941"
    })
    photo_3 = Photograph.new({
         id: "3",
         name: "Identical Twins, Roselle, New Jersey",
         artist_id: "3",
         year: "1967"
    })
    photo_4 = Photograph.new({
         id: "4",
         name: "Monolith, The Face of Half Dome",
         artist_id: "3",
         year: "1927"
    })
    artist_1 = Artist.new({
         id: "1",
         name: "Henri Cartier-Bresson",
         born: "1908",
         died: "2004",
         country: "France"
    })
    artist_2 = Artist.new({
         id: "2",
         name: "Ansel Adams",
         born: "1902",
         died: "1984",
         country: "United States"
    })
    artist_3 = Artist.new({
         id: "3",
         name: "Diane Arbus",
         born: "1923",
         died: "1971",
         country: "United States"
    })
    curator.add_artist(artist_1) #52340
    curator.add_artist(artist_2) # 6c20870
    curator.add_artist(artist_3) # 5ba0c70
    curator.add_photograph(photo_1) #c6933180
    curator.add_photograph(photo_2) #c6c28e58
    curator.add_photograph(photo_3) #5bb9ef0
    curator.add_photograph(photo_4) #6b931f0
    expected = [photo_2, photo_3, photo_4]

    assert_equal expected, curator.photographs_taken_by_artist_from("United States")
    assert_equal [], curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_it_can_load_photographs
    curator = Curator.new
    curator.load_photographs('./data/photographs.csv')

    assert_equal 4, curator.photographs.length
    assert_equal "1962", curator.photographs[3].year
  end

  def test_it_can_load_artists
    curator = Curator.new
    curator.load_artists('./data/artists.csv')

    assert_equal 6, curator.artists.length
    assert_equal "Diane Arbus", curator.artists[2].name
  end

  def test_it_can_tell_photographs_taken_between_two_years
    curator = Curator.new
    curator.load_photographs('./data/photographs.csv')
    photo_1 = curator.photographs[0]
    photo_2 = curator.photographs[3]
    expected = [photo_1, photo_2]

    assert_equal expected, curator.photographs_taken_between(1950..1965)
  end

  def test_it_can_tell_artists_photographs_by_age
    curator = Curator.new
    curator.load_artists('./data/artists.csv')
    curator.load_photographs('./data/photographs.csv')
    diane_arbus = curator.find_artist_by_id("3")
    expected = {
      44=>"Identical Twins, Roselle, New Jersey",
      39=>"Child with Toy Hand Grenade in Central Park"
    }
    
    assert_equal expected, curator.artists_photographs_by_age(diane_arbus)
  end
end
