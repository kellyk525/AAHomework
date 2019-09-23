class Artist < ApplicationRecord
  has_many :albums,
    class_name: 'Album',
    foreign_key: :artist_id,
    primary_key: :id

  def n_plus_one_tracks
    albums = self.albums
    tracks_count = {}
    albums.each do |album|
      tracks_count[album.title] = album.tracks.length
    end

    tracks_count
  end

  def better_tracks_query
    # TODO: your code here

    albums = self.albums.includes(:tracks)
    album_track_counts = {}
    albums.each do |album|
      album_track_counts[album.title] = album.tracks.length
    end
    album_track_counts
  end
end

    # albums = self
    #   .albums
    #   .select('albums.*, COUNT(*) AS tracks_count')
    #   .joins(:tracks)
    #   .group('albums.id')
      
