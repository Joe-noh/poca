<script>
  let { name } = $props();
  let message = $state("");

  $effect(() => {
    message = `Hello, I'm ${name}`;
  });
</script>

<p>{message}</p>
