<script lang="ts">
  import { Router } from "sv-router";
  import { QueryClient, QueryClientProvider } from "@tanstack/svelte-query";
  import "./router.ts";

  const queryClient = new QueryClient();
</script>

<QueryClientProvider client={queryClient}>
  <Router />
</QueryClientProvider>
