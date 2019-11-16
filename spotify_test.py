# Script to mess around with User authenticated spotify API
# For some reason, cannot authenticate with Google Chrome, so instead use Firefox
# http://spotipy.readthedocs.io/en/latest/

from pathlib import Path
from spotipy.oauth2 import SpotifyClientCredentials
import json
import spotipy
import time
import sys
import spotipy.util as util
import pandas as pd

# Set up directory and read credentials
directory = Path(__file__).resolve().parent
infile = open(directory / "credentials.txt", 'r').readlines()

username = "liltkrookie"
scope = "user-top-read"
sort = "tempo"

print(infile[0])
# Send crendetials and ping Spotify API
token = util.prompt_for_user_token(username,scope,client_id='8d3383fc5c434af5bf40fb7b2915c618',client_secret=infile[0],redirect_uri='http://localhost:8888/callback')
client_credentials_manager = SpotifyClientCredentials(client_id='8d3383fc5c434af5bf40fb7b2915c618', client_secret=infile[0])
sp = spotipy.Spotify(auth=token)

playlistdata = sp.current_user_top_tracks(limit=50, offset=0, time_range='medium_term')
playlist_json = json.dumps(playlistdata,indent=4)
track_list = json.loads(playlist_json)

num = len(track_list['items'])
tid=[]
for i in range(0, num):
    uri =track_list['items'][i]['uri']
    tid.append(uri)

# Song Audiofeatures
analysis = sp.audio_features(tid)
sample_json = json.dumps(analysis)
data = pd.read_json(sample_json)

# print(data)

# Song Metadata
analysis2 = sp.tracks(tid)
sample_json2 = json.dumps(analysis2)
data2 = json.loads(sample_json2)
songdata=[]
songlabels=['song','uri','artist']
for i in range(0, num):
    name=data2['tracks'][i]['name']
    uri =data2['tracks'][i]['uri']
    artist =data2['tracks'][i]['album']['artists'][0]['name']
    songdata.append([name, uri, artist])
song_metadata = pd.DataFrame.from_records(songdata, columns=songlabels)

# print(song_metadata)
# DataFrame merge
export = pd.merge(song_metadata,data, how = 'outer', on =['uri'])
writer = pd.ExcelWriter(directory / 'top_played_songs.xlsx')
export.to_excel(writer,'Sheet1')
writer.save()

dfList = export['uri'].tolist()
print ("Completed download and export of top played songs")