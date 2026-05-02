defmodule Poca.Fixtures do
  @moduledoc """
  Test fixtures for the Poca application.
  """

  alias Poca.{Accounts, Podcasts}

  def signup_user(_) do
    Accounts.signup_with_google("12345")
  end

  def create_podcast(overwrite \\ %{}) do
    %{
      title: "I am Mr. Talk",
      author: "Mr. Talk",
      feed_url: "http://example.com/feed",
      artwork_url: "https://example.com/thumbnail.jpg"
    }
    |> Map.merge(overwrite)
    |> Podcasts.create_podcast()
  end

  def create_episode(podcast, overwrite \\ %{}) do
    attrs = %{
      guid: Ecto.UUID.generate(),
      title: "Episode title",
      description: "Episode description",
      audio_url: "http://example.com/audio.mp3",
      duration: 1230,
      published_at: DateTime.utc_now()
    }

    {:ok, episode} =
      podcast
      |> Ecto.build_assoc(:episodes)
      |> Ecto.Changeset.change(Map.merge(attrs, overwrite))
      |> Poca.Repo.insert()

    {:ok, %{episode: episode}}
  end

  def feed_fixture do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:content="http://purl.org/rss/1.0/modules/content/"
      xmlns:atom="http://www.w3.org/2005/Atom" version="2.0"
      xmlns:anchor="https://anchor.fm/xmlns"
      xmlns:podcast="https://podcastindex.org/namespace/1.0"
      xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
      xmlns:psc="http://podlove.org/simple-chapters">
      <channel>
        <title><![CDATA[I am Mr. Talk]]></title>
        <description>
          <![CDATA[Welcome to Mr. Talk's podcast, where we dive into the world of self-improvement to becoming the best version of yourself.]]>
        </description>
        <link>https://example.com</link>
        <generator>Anchor Podcasts</generator>
        <lastBuildDate>Tue, 21 Apr 2026 07:00:00 GMT</lastBuildDate>
        <atom:link href="https://anchor.fm/s/12345/podcast/rss" rel="self" type="application/rss+xml"/>
        <author><![CDATA[Mr. Talk]]></author>
        <copyright><![CDATA[Mr. Talk]]></copyright>
        <language><![CDATA[en-us]]></language>
        <atom:link rel="hub" href="https://pubsubhubbub.appspot.com/"/>
        <itunes:author>Mr. Talk</itunes:author>
        <itunes:summary>
          Welcome to Mr. Talk's podcast, where we dive into the world of self-improvement to becoming the best version of yourself.
        </itunes:summary>
        <itunes:type>episodic</itunes:type>
        <itunes:owner>
          <itunes:name>Mr. Talk</itunes:name>
          <itunes:email>owner@example.com</itunes:email>
        </itunes:owner>
        <itunes:explicit>true</itunes:explicit>
        <itunes:category text="Education">
          <itunes:category text="Self-Improvement"/>
        </itunes:category>
        <itunes:image href="https://example.com/thumbnail.jpg"/>
        <item>
          <title><![CDATA[I am Mr. Talk (Trailer)]]></title>
          <link>https://example.com/episodes/100</link>
          <guid isPermaLink="false">04643da1-601c-4c4d-a2d5-1b9262b8e4e7</guid>
          <dc:creator><![CDATA[Mr. Talk]]></dc:creator>
          <pubDate>Tue, 02 Jan 2024 06:00:00 GMT</pubDate>
          <enclosure url="https://example.com/episodes/100/audio.m4a" length="987654" type="audio/x-m4a"/>
          <itunes:explicit>false</itunes:explicit>
          <itunes:duration>00:05:00</itunes:duration>
          <itunes:image href="https://example.com/episodes/100/thumbnail.jpg"/>
          <itunes:episodeType>trailer</itunes:episodeType>
        </item>
      </channel>
    </rss>
    """
  end
end
