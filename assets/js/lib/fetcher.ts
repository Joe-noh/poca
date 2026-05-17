import { toCamelCaseKeys } from "es-toolkit/object";

export function get<T>(path: string): Promise<T> {
  return fetch(path)
    .then((res) => res.json())
    .then((data) => toCamelCaseKeys(data) as T);
}

export function post<T>(path: string, body: any): Promise<T> {
  const params: RequestInit = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };

  return fetch(path, params)
    .then((res) => res.json())
    .then((data) => toCamelCaseKeys(data) as T);
}

export function put<T>(path: string, body: any): Promise<T> {
  const params: RequestInit = {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };

  return fetch(path, params)
    .then((res) => res.json())
    .then((data) => toCamelCaseKeys(data) as T);
}

export function del<T>(path: string): Promise<T> {
  const params: RequestInit = {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
    },
  };

  return fetch(path, params)
    .then((res) => res.json())
    .then((data) => toCamelCaseKeys(data) as T);
}
