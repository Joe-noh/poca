defmodule Poca.Podcasts do
  @moduledoc """
  The Podcasts context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Poca.Repo
  alias Poca.Podcasts.{Podcast, Subscription, Feed}
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
  def refresh_episodes(%Podcast{feed_url: feed_url}) do
    case Feed.fetch(feed_url) do
      {:ok, feed} ->
        {:ok, feed}

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
end
