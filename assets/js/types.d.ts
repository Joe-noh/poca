type Podcast = {
  id: string;
  title: string;
  author: string;
  description: string;
  link: string;
  artworkUrl: string;
};

type Episode = {
  id: string;
  guid: string;
  title: string;
  description: string;
  audioUrl: string;
  duration: number;
  publishedAt: string;
  podcast: Podcast;
  playback?: Playback;
};

type Playback = {
  id: string;
  currentTime: number;
  duration: number;
  progress: number;
};

declare module "*.svg" {
  const content: string;
  export default content;
}
