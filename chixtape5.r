#----------------------------------------------#
#---------------Spotify API in R --------------#
#----------------------------------------------#
# Written by: Trent Kajikawa
# Purpose: Let's do an analysis comparing Tory Lanez's Chixtape 5 and the samples used
# Inspired by: https://msmith7161.github.io/what-is-speechiness/
#              https://developer.spotify.com/documentation/web-api/reference-beta/#category-tracks

# Clean workspace
rm(list = ls())

# If we don't have spotifyr, make sure to install
# install.packages('spotifyr')
library(spotifyr)
library(ggplot2)
library(httpuv)
library(dplyr)
# Let's set up the authentication
Sys.setenv(SPOTIFY_CLIENT_ID = '8d3383fc5c434af5bf40fb7b2915c618')
fileName <- 'spotify_api/credentials.txt'
Sys.setenv(SPOTIFY_CLIENT_SECRET = readChar(fileName, file.info(fileName)$size))
access_token <- get_spotify_access_token()
import <- get_playlist_audio_features("liltkrookie", "3Lb30qkvIF8snmxpUjkqP8")

# Get metadata of playlist
library(vtable)

# Create a flag for Chixtape (factor)
import$chixtape <- 0
import$chixtape[import$track.album.name=='Chixtape 5'] <- 1

# Parse down the data we want for analysis
var_list <- c("danceability"
              ,"energy"
              ,"key"
              ,"loudness"
              ,"mode"
              ,"speechiness"
              ,"acousticness"
              ,"instrumentalness"
              ,"liveness"
              ,"valence"
              ,"tempo"
              ,"track.id"
              ,"time_signature"
              ,"track.popularity"
              ,"track.track_number"
              ,"track.duration_ms"
              ,"track.artists"
              ,"track.name"
              ,"track.album.name"
              ,"chixtape")
analysis_file = import[var_list]

# Split the datat if we want
chixtape_data <- analysis_file[which (analysis_file$track.album.name=='Chixtape 5'),]
sample_data <- analysis_file[which (analysis_file$track.album.name!='Chixtape 5'),]