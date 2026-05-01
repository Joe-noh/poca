defmodule Poca.Podcasts do
  @moduledoc """
  The Podcasts context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Poca.Repo
  alias Poca.Podcasts.{Podcast, Episode, Subscription, Playback, Feed}
  alias Poca.Accounts.User

  @doc """
  Returns the list of podcasts.

  ## Examples

      iex> list_podcasts()
      [%Podcast{}, ...]

  """
  def list_podcasts do
    Repo.all(Podcast)
  end

  def get_podcast(id, opts \\ []) do
    query = Podcast |> where([p], p.id == ^id)

    query =
      case Keyword.get(opts, :user) do
        user = %User{} -> preload_subscribers(query, user)
        nil -> query
      end

    Repo.one(query)
  end

  def get_podcast_by_feed_url(feed_url, opts \\ [])

  def get_podcast_by_feed_url(nil, _opts), do: nil

  def get_podcast_by_feed_url(feed_url, opts) do
    query = Podcast |> where([p], p.feed_url == ^feed_url)

    query =
      case Keyword.get(opts, :user) do
        user = %User{} -> preload_subscribers(query, user)
        nil -> query
      end

    Repo.one(query)
  end

  defp preload_subscribers(query, %User{id: user_id}) do
    query
    |> join(:left, [p], s in assoc(p, :subscribers), on: s.id == ^user_id, as: :subscribers)
    |> preload([p, subscribers: s], subscribers: s)
  end

  def subscribed_podcasts(%User{id: user_id}) do
    podcasts =
      Podcast
      |> join(:inner, [p], s in assoc(p, :subscribers), on: s.id == ^user_id, as: :subscribers)
      |> preload([p, subscribers: s], subscribers: s)
      |> order_by([p], desc: p.inserted_at)
      |> Repo.all()

    podcasts = count_episodes(podcasts)

    {:ok, %{podcasts: podcasts}}
  end

  def count_episodes(podcasts) do
    podcast_ids = Enum.map(podcasts, & &1.id)

    counts =
      Episode
      |> where([e], e.podcast_id in ^podcast_ids)
      |> group_by([e], e.podcast_id)
      |> select([e], {e.podcast_id, count(e.id)})
      |> Repo.all()
      |> Map.new()

    Enum.map(podcasts, fn podcast ->
      Map.put(podcast, :episodes_count, Map.get(counts, podcast.id, 0))
    end)
  end

  def create_podcast(attrs \\ %{}) do
    case get_podcast_by_feed_url(attrs["feed_url"]) do
      nil ->
        Multi.new()
        |> Multi.insert(:podcast, Podcast.changeset(%Podcast{}, attrs), returning: true, on_conflict: :nothing, conflict_target: :feed_url)
        |> Repo.transact()

      podcast ->
        {:ok, %{podcast: podcast}}
    end
  end

  def update_podcast(%Podcast{} = podcast, attrs) do
    Multi.new()
    |> Multi.update(:podcast, Podcast.changeset(podcast, attrs))
    |> Repo.transact()
  end

  @doc """
  Fetches podcast details from its feed URL and updates the podcast record.
  """
  def refresh_podcast(%Podcast{feed_url: feed_url} = podcast) do
    case Feed.fetch(feed_url) do
      {:ok, feed} ->
        %{"title" => title, "description" => description, "link" => link, "itunes_ext" => ext} = feed
        %{"author" => author, "image" => image} = ext

        update_podcast(podcast, %{
          title: title,
          author: author,
          description: description,
          link: link,
          artwork_url: image
        })

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches the latest episodes for a given podcast by parsing its feed URL.
  """
  def refresh_episodes(%Podcast{id: id, feed_url: feed_url} = podcast) do
    now = DateTime.utc_now()

    case Feed.fetch(feed_url) do
      {:ok, %{"items" => items}} ->
        episodes =
          Enum.map(items, fn item ->
            %{
              "title" => title,
              "description" => description,
              "pub_date" => pub_date,
              "guid" => %{"value" => guid},
              "enclosure" => %{"url" => audio_url},
              "itunes_ext" => %{"duration" => duration}
            } = item

            %{
              podcast_id: id,
              guid: guid,
              title: title,
              description: description,
              audio_url: audio_url,
              duration: Feed.parse_duration(duration),
              published_at: Feed.parse_pub_date(pub_date),
              inserted_at: now,
              updated_at: now
            }
          end)

        Repo.transact(fn ->
          {:ok, %{podcast: podcast}} = update_podcast(podcast, %{last_fetched_at: now})
          Poca.Repo.insert_all(Episode, episodes, on_conflict: :replace_all, conflict_target: [:podcast_id, :guid])

          {:ok, podcast}
        end)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Subscribes a user to a podcast. Do nothing if the user is already subscribed.
  """
  def subscribe(%Podcast{} = podcast, user) do
    changeset = Subscription.changeset(%Subscription{user_id: user.id, podcast_id: podcast.id}, %{})

    Multi.new()
    |> Multi.insert(:subscription, changeset, on_conflict: :nothing)
    |> Repo.transact()
  end

  @doc """
  Unsubscribes a user from a podcast. Do nothing if the user is not subscribed.
  """
  def unsubscribe(%Podcast{} = podcast, user) do
    Multi.new()
    |> Multi.delete_all(:subscription, from(s in Subscription, where: s.user_id == ^user.id and s.podcast_id == ^podcast.id))
    |> Repo.transact()
  end

  def get_episode(id) do
    Episode |> where([e], e.id == ^id) |> preload(:podcast) |> Repo.one()
  end

  def subscribed_episodes(%User{id: user_id}) do
    episodes =
      Episode
      |> join(:inner, [e], p in assoc(e, :podcast), as: :podcast)
      |> join(:inner, [e, podcast: p], s in Subscription, on: s.podcast_id == p.id and s.user_id == ^user_id, as: :subscription)
      |> join(:left, [e, podcast: p], pb in Playback, on: pb.episode_id == e.id and pb.user_id == ^user_id, as: :playback)
      |> preload([e, podcast: p, playback: pb], podcast: p, playback: pb)
      |> order_by([e], desc: e.published_at)
      |> limit(100)
      |> Repo.all()

    {:ok, %{episodes: episodes}}
  end

  def get_playback(episode, user) do
    Playback
    |> where([pb], pb.episode_id == ^episode.id and pb.user_id == ^user.id)
    |> Repo.one()
  end

  def save_playback_progress(user, episode, current_time, duration) do
    changeset =
      %Playback{user_id: user.id, episode_id: episode.id}
      |> Playback.changeset(%{current_time: current_time, duration: duration})

    Multi.new()
    |> Multi.insert(:playback, changeset, on_conflict: {:replace_all_except, [:id, :user_id, :episode_id]}, conflict_target: [:user_id, :episode_id])
    |> Repo.transact()
  end
end
