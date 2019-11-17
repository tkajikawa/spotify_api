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
# Let's set up the authentication
Sys.setenv(SPOTIFY_CLIENT_ID = '8d3383fc5c434af5bf40fb7b2915c618')
fileName <- 'spotify_api/credentials.txt'
Sys.setenv(SPOTIFY_CLIENT_SECRET = readChar(fileName, file.info(fileName)$size))
access_token <- get_spotify_access_token()
import <- get_playlist_audio_features("liltkrookie", "3Lb30qkvIF8snmxpUjkqP8")

# Get metadata of playlist
library(vtable)

# Split the datat if we want
chixtape_data <- import[which (import$track.album.name=='Chixtape 5'),]
sample_data <- import[which (import$track.album.name!='Chixtape 5'),]

# Create a flag for Chixtape (factor)
import$chixtape <- 0
import$chixtape[import$track.album.name=='Chixtape 5'] <- 1

# Basic plotst
par(mfrow=c(2,5))
boxplot(danceability~chixtape, data=import)
boxplot(energy~chixtape, data=import)
boxplot(valence~chixtape, data=import)
boxplot(tempo~chixtape, data=import)
boxplot(speechiness~chixtape, data=import)
boxplot(loudness~chixtape, data=import)
boxplot(liveness~chixtape, data=import)
# boxplot(instrumentalness~chixtape, data=import)
boxplot(acousticness~chixtape, data=import)
boxplot(track.duration_ms~chixtape, data=import)
boxplot(track.popularity~chixtape, data=import)