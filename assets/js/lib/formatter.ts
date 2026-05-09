export function formatDuration(duration: number): string {
  const pad_zero = (num: number) => num.toString().padStart(2, "0");

  const hours = Math.floor(duration / 3600);
  const minutes = Math.floor((duration % 3600) / 60);
  const seconds = duration % 60;

  if (hours > 0) {
    return `${hours}:${pad_zero(minutes)}:${pad_zero(seconds)}`;
  } else if (minutes > 0) {
    return `${minutes}:${pad_zero(seconds)}`;
  } else {
    return `0:${pad_zero(seconds)}`;
  }
}

export function formatDateTime(dateTime: string): string {
  const date = new Date(dateTime);
  const formatter = new Intl.DateTimeFormat(undefined, {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });

  return formatter.format(date);
}
