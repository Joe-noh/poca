import { toCamelCaseKeys } from "es-toolkit/object";

export function get<T>(path: string): Promise<T> {
  return fetch(path)
    .then((res) => res.json())
    .then((data) => toCamelCaseKeys(data) as T);
}
