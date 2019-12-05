# -*- coding: utf-8 -*-
"""
Spyder Editor

 ## Tweepy is a Python module that allows someone to grab or mine data        from Twitter either in real time or from a set range of time. You can do        a lot with Python and Twitter: you can tweet from it, but most importantly for research, you can use it to analyze trends in real time, analyze word usages and hashtag frequencies in both real time and using an extractor, and analyze sentiment of tweets using different Twitter clients. This is useful for all kinds of research: marketing, opinion, and political opinion, to name a few. I am interested in using Twitter to analyze public opinion on different political topics. I am hoping to use sentiment analysis tools to gauge the sentiment of the 2020 election, but for now I have done a simple Python program using tweepy to see common words and bigrams (two words next to each other) on the topic of impeachment. Twitter's free API limits you to 400 queries a day, 100 tweets per query, and makes you wait 15 minutes in between each query, so it can be time consuming and complicated if you want to do larger projects for free. I will be showing some of the code I used and have a small Powerpoint presentation with some graphs for visualization.##

pip install tweepy

import tweepy

# The following are my Twitter Developer credentials, which allows the API I created to run #

consumer_key= 'Xr9VwmlPNLT2NivIMWUPPYysT'
consumer_secret= 'SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1'
access_token= '286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm'
access_token_secret= 'oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy'
auth = tweepy.OAuthHandler("Xr9VwmlPNLT2NivIMWUPPYysT", "SaI9MpQkArKRU4W9KQBG3gpojporZihUQkpJcCa46G11gzsWD1")

auth.set_access_token("286826733-tQpQY605CrxvFQr8DKp4nvEcIdnXBhsSTaiGIELm", "oNL954A1GiJAu8SaNBw9axSQiPky3cY60l4AIYSBLaOyy")

# This next bit tells tweepy to wait when the rate limit from the Twitter API has been reached. The other option is to set it to sleep while it waits for rate limit to reset (the free Twitter API sets a limit for how much you can query, then makes you wait 15 minutes) #

api = tweepy.API(auth, wait_on_rate_limit=True,
    wait_on_rate_limit_notify=True)

# The following defines the search term and the date_since date as variables #

search_words = "#Impeachment"
date_since = "2019-09-08"

tweets = tweepy.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(250)
tweets

tweets = tweepy.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(250)
tweets

# Collect more tweets #

tweets = tweepy.Cursor(api.search,
                       q=search_words,
                       lang="en",
                       since=date_since).items(50)

# Collect a list of tweets #

[tweet.text for tweet in tweets]

new_search = "Impeachment +  -filter:retweets"
new_search

tweets = tweepy.Cursor(api.search,
                       q=new_search,
                       lang="en",
                       since=date_since).items(25)

[tweet.text for tweet in tweets]

tweets = tweepy.Cursor(api.search, 
                           q=new_search,
                           lang="en",
                           since=date_since).items(25)

users_locs = [[tweet.user.screen_name, tweet.user.location] for tweet in tweets]
users_locs

import pandas

tweet_text = pandas.DataFrame(data=users_locs, 
                    columns=['user', "location"])
tweet_text

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import itertools
import collections

import tweepy as tw
import nltk
from nltk.corpus import stopwords
import re
import networkx

# The next bit filters python warnings so the code isn't stopped #

import warnings
warnings.filterwarnings("ignore")

sns.set(font_scale=1.5)
sns.set_style("whitegrid")

search_term = "#Impeachment -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-09-08').items(1000)

all_tweets = [tweet.text for tweet in tweets]

all_tweets[:250]

#  The following loop replaces URLs found in a text string with nothing #
#(in other words, it removes the URL from the string) #


def remove_url(txt):
   

    return " ".join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", "", txt).split())

all_tweets_no_urls = [remove_url(tweet) for tweet in all_tweets]
all_tweets_no_urls[:250]

# I want to make all elements in the list lowercase #

all_tweets_no_urls[0].lower().split()

words_in_tweet = [tweet.lower().split() for tweet in all_tweets_no_urls]
words_in_tweet[:2]

# List of all words across tweets #

all_words_no_urls = list(itertools.chain(*words_in_tweet))

# Create counter #

counts_no_urls = collections.Counter(all_words_no_urls)

counts_no_urls.most_common(15)

clean_tweets_no_urls = pd.DataFrame(counts_no_urls.most_common(15),
                             columns=['words', 'count'])

clean_tweets_no_urls.head()

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph #

clean_tweets_no_urls.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets About Impeachment (Including All Words)")

plt.show()

nltk.download('stopwords')
stop_words = set(stopwords.words('english'))

# View a few words from the set
list(stop_words)[0:10]
words_in_tweet[0]
tweets_nsw = [[word for word in tweet_words if not word in stop_words]
              for tweet_words in words_in_tweet]

tweets_nsw[0]

all_words_nsw = list(itertools.chain(*tweets_nsw))

counts_nsw = collections.Counter(all_words_nsw)

counts_nsw.most_common(15)

clean_tweets_nsw = pd.DataFrame(counts_nsw.most_common(15),
                             columns=['words', 'count'])

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_nsw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets About Impeachment (Without Stop Words)")

plt.show()

collection_words = ['impeachment']

tweets_nsw_nc = [[w for w in word if not w in collection_words]
                 for word in tweets_nsw]
tweets_nsw[0]
tweets_nsw_nc[0]

# Flatten list of words in clean tweets #
all_words_nsw_nc = list(itertools.chain(*tweets_nsw_nc))

# Now create a counter of words in clean tweets #

counts_nsw_nc = collections.Counter(all_words_nsw_nc)

counts_nsw_nc.most_common(15)
len(counts_nsw_nc)

clean_tweets_ncw = pd.DataFrame(counts_nsw_nc.most_common(15),
                             columns=['words', 'count'])
clean_tweets_ncw.head()

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph #

clean_tweets_ncw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets About Impeachment (Without Stop or Collection Words)")

plt.show()

from nltk import bigrams
from nltk.corpus import stopwords
import re

import networkx as nx

# The following creates list of lists containing bigrams in tweets. Bigrams are words next to each other #

terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw_nc]

# View bigrams for the first tweet
terms_bigram[0]

tweets_nsw_nc[0]

# Flatten list of bigrams in clean tweets #

bigrams = list(itertools.chain(*terms_bigram))

# Now create counter of words in clean bigrams #
bigram_counts = collections.Counter(bigrams)

bigram_counts.most_common(25)

bigram_df = pd.DataFrame(bigram_counts.most_common(20),
                             columns=['bigram', 'count'])

bigram_df

# Create dictionary of bigrams and their counts
d = bigram_df.set_index('bigram').T.to_dict('records')

# Create network plot 
G = nx.Graph()

# Create connections between nodes
for k, v in d[0].items():
    G.add_edge(k[0], k[1], weight=(v * 10))

G.add_node("ukraine", weight=100)

fig, ax = plt.subplots(figsize=(10, 8))

pos = nx.spring_layout(G, k=1)

# Plot networks
nx.draw_networkx(G, pos,
                 font_size=16,
                 width=3,
                 edge_color='grey',
                 node_color='purple',
                 with_labels = False,
                 ax=ax)

# Create offset labels
for key, value in pos.items():
    x, y = value[0]+.135, value[1]+.045
    ax.text(x, y,
            s=key,
            bbox=dict(facecolor='red', alpha=0.25),
            horizontalalignment='center', fontsize=13)
    
plt.show()

labels = 'Democrats', 'Pelosi', 'Trump', 'House'
sizes = [15, 30, 45, 10]
explode = (0, 0, 0.1, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')

fig1, ax1 = plt.subplots()
ax1.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

plt.show()


####################################################################################################################################
